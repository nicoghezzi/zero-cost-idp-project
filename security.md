# Security Architecture: Secretless Infrastructure

This project implements **Shift-Left Security** by eliminating static IAM credentials. 

### 🛡️ OIDC Federation
Instead of storing long-lived AWS Access Keys in GitHub Secrets, this IDP uses **OpenID Connect (OIDC)**. 
- **Identity Provider:** AWS trust relationship with `token.actions.githubusercontent.com`.
- **Short-Lived Tokens:** GitHub Actions requests a temporary, 1-hour STS token from AWS.
- **Least Privilege:** The IAM Role is scoped strictly to this specific GitHub repository (`repo:nicoghezzi/zero-cost-idp-project:*`).

### 🚀 Why ?
By removing static keys, we have eliminated the risk of credential leakage, which is the #1 cause of cloud data breaches.