# 1. Keep the Role
resource "aws_iam_role" "github_role" {
  name = "github-action-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Action = "sts:AssumeRoleWithWebIdentity",
        Effect = "Allow",
        Principal = { Federated = "arn:aws:iam::943066268094:oidc-provider/token.actions.githubusercontent.com" },
        Condition = { StringLike = { "token.actions.githubusercontent.com:sub": "repo:nicoghezzi/zero-cost-idp-project:*" } }
    }]
  })
}

# 2. ADD THIS BACK - This is why it was trying to delete the policy!
resource "aws_iam_role_policy_attachment" "admin_policy" {
  role       = aws_iam_role.github_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# 3. S3 Infrastructure
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

# 4. The Policy that fixes the 403 error
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

# --- FinOps: The Cost Shield ---

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
    subscriber_email_addresses = ["YOUR_EMAIL@EXAMPLE.COM"] # <--- Update this!
  }
}