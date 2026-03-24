# This creates the "Trust" between AWS and GitHub
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# This creates the "Role" that GitHub will "wear" when it logs into AWS
resource "aws_iam_role" "github_role" {
  name = "github-action-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity",
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        },
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub": "repo:nicoghezzi/zero-cost-idp-project:*"
          }
        }
      }
    ]
  })
}

# This gives the Role permission to build things (Admin access)
resource "aws_iam_role_policy_attachment" "admin_policy" {
  role       = aws_iam_role.github_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# This prints out the ID of the role so we can use it in GitHub later
output "github_role_arn" {
  value = aws_iam_role.github_role.arn
}

# This creates a unique name for your bucket
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# This creates the actual S3 Bucket (The "Folder" in the Cloud)
resource "aws_s3_bucket" "website" {
  bucket = "my-idp-site-${random_id.bucket_suffix.hex}"
}

# This tells AWS the bucket is for a Website
resource "aws_s3_bucket_website_configuration" "site_config" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }
}

# This makes the bucket public so people can see your site
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# This prints the URL of your new website
output "website_url" {
  value = aws_s3_bucket_website_configuration.site_config.website_endpoint
}