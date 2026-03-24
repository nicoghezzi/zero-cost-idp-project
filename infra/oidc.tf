/* # Comment this out so GitHub Actions doesn't try to recreate it
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}
*/

resource "aws_iam_role" "github_role" {
  name = "github-action-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity",
        Effect = "Allow",
        Principal = {
          # Use the hardcoded ARN from your terminal output
          Federated = "arn:aws:iam::943066268094:oidc-provider/token.actions.githubusercontent.com"
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

# ... (Keep the rest of your S3 and output code below)