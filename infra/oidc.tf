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