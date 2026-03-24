# --- 1. THE RECOVERY PIECE: OIDC Provider ---
# This was missing! It creates the trust between GitHub and AWS.
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# --- 2. IAM Role & Policy ---
resource "aws_iam_role" "github_role" {
  name = "github-action-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Action = "sts:AssumeRoleWithWebIdentity",
        Effect = "Allow",
        Principal = { 
          # We link directly to the provider created above
          Federated = aws_iam_openid_connect_provider.github.arn 
        },
        Condition = { 
          StringLike = { "token.actions.githubusercontent.com:sub": "repo:nicoghezzi/zero-cost-idp-project:*" } 
        }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "admin_policy" {
  role       = aws_iam_role.github_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# --- 3. S3 Infrastructure ---
resource "aws_s3_bucket" "website" {
  bucket = "my-idp-site-0652f8f0"
}

resource "aws_s3_bucket_website_configuration" "site_config" {
  bucket = aws_s3_bucket.website.id
  index_document { suffix = "index.html" }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_public_read" {
  bucket = aws_s3_bucket.website.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website.arn}/*"
    }]
  })
}

# --- 4. FinOps: The Cost Shield ---
resource "aws_budgets_budget" "zero_cost_limit" {
  name              = "idp-zero-cost-limit"
  budget_type       = "COST"
  limit_amount      = "1.0"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = ["YOUR_EMAIL@EXAMPLE.COM"] # <--- REMEMBER TO UPDATE THIS
  }
}

# --- 5. Outputs ---
output "website_url" {
  value = aws_s3_bucket_website_configuration.site_config.website_endpoint
}