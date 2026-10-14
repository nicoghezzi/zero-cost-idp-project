# 🚀 Zero-Cost Internal Developer Platform (IDP)

![Security: OIDC](https://img.shields.io/badge/Security-OIDC%20Keyless-green?style=for-the-badge&logo=shield)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)

A production-ready, **$0-cost** automated infrastructure pipeline. This project demonstrates how to securely bridge GitHub Actions and AWS using **OIDC (OpenID Connect)** to deploy a high-availability static portal without managing long-lived IAM keys.

🔗 **Live Demo:** [View IDP Portal](http://my-idp-site-0652f8f0.s3-website-us-east-1.amazonaws.com/)

---

## 🏗️ Architecture
The project implements a modern DevOps workflow where infrastructure is treated as code, and security is handled via identity federation.

1. **Infrastructure:** Provisioned via **Terraform** (S3, IAM, OIDC).
2. **Security:** **Keyless Authentication** using AWS IAM Identity Providers (OIDC).
3. **Frontend:** Responsive HTML5/CSS3 portal.
4. **CI/CD:** Automated deployment via **GitHub Actions** on every `git push`.

---

## 🌟 Key Features
* **Zero-Trust Security:** Uses short-lived STS tokens instead of permanent IAM credentials.
* **State Management:** Local Terraform state tracking for modular updates.
* **Automated Sync:** GitHub Actions automatically invalidates and updates the S3 content.
* **Public Read Access:** Custom JSON bucket policies for granular permission control.

---

## 🧠 Engineering Decisions & Trade-offs

| Decision | Rationale | Trade-off |
|---|---|---|
| **OIDC over static AWS keys** | Avoids storing long-lived AWS credentials in GitHub Secrets and uses temporary STS credentials. | Requires carefully scoped trust policies, workflow permissions, and IAM role permissions. |
| **Terraform over manual provisioning** | Makes infrastructure repeatable, reviewable, and version-controlled. | Introduces state-management responsibilities and the need to review plans before applying changes. |
| **S3 over containers or Kubernetes** | Keeps hosting simple and avoids unnecessary compute and orchestration for a static website. | S3 static website endpoints do not provide HTTPS directly; a production design could use CloudFront and TLS. |
| **Local Terraform state** | Keeps the initial project simple without additional backend infrastructure. | Less suitable for team collaboration and recovery; a shared environment should use protected remote state and appropriate locking. |
| **AWS Budgets for cost monitoring** | Provides visibility through configurable spending thresholds and email alerts. | Alerts do not enforce a hard spending limit, and billing data may be delayed. |

These decisions prioritize simplicity, reduced credential exposure, repeatability, and cost awareness while documenting the limitations that would need to be addressed as the platform scales.

---

## 🔒 Shift-Left Security: The OIDC Master
Most beginner projects use "IAM User Keys" stored in GitHub Secrets. This project uses identity federation to reduce reliance on long-lived credentials.

1. **No Static AWS Keys:** No AWS access keys are stored in this repository.
2. **Identity Federation:** Uses `aws-actions/configure-aws-credentials` to authenticate GitHub Actions with AWS through OIDC.
3. **Automated Governance:** Infrastructure and access policies are defined in Terraform for consistent, repeatable provisioning.

### 🔑 The Security Proof
The OIDC trust relationship restricts access using the GitHub identity's `sub` claim.

- **Method:** OIDC Federation with temporary STS credentials.
- **Scope:** Restricted to the specified GitHub repository.
- **Policy Condition:** `"token.actions.githubusercontent.com:sub": "repo:nicoghezzi/zero-cost-idp-project:*"`

---

## 🛡️ Governance & FinOps

This project incorporates cost monitoring and infrastructure recovery into the deployment workflow.

* **Automated Cost Guardrails:** Implements `aws_budgets_budget` through Terraform, with email alerts configured for a $1.00 monthly threshold.
* **Infrastructure Resilience:** During development, simulated a provider failure and used Terraform state management to restore the OIDC trust relationship in under 60 seconds.
* **Identity Federation:** Eliminates long-lived AWS access keys from the GitHub Actions authentication workflow.

**Scope:** This is a cost-conscious reference implementation, not a guarantee of zero operating cost or complete production readiness.

## 🚀 Author
Nicolas Ghezzi 
LinkedIn: https://www.linkedin.com/in/nghezzi/
