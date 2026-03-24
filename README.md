# 🚀 Zero-Cost Internal Developer Platform (IDP)

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

## 🛠️ Tech Stack
* **Cloud:** Amazon Web Services (S3, IAM)
* **IaC:** Terraform v1.x
* **CI/CD:** GitHub Actions
* **Security:** OIDC Federation (No AWS Access Keys stored in GitHub)

---

## 🌟 Key Features
* **Zero-Trust Security:** Uses short-lived STS tokens instead of permanent IAM credentials.
* **State Management:** Local Terraform state tracking for modular updates.
* **Automated Sync:** GitHub Actions automatically invalidates and updates the S3 content.
* **Public Read Access:** Custom JSON bucket policies for granular permission control.

---

## 🚀 Deployment Instructions

### Prerequisites
* AWS CLI configured
* Terraform installed
* GitHub Repository

### Local Setup
1. Clone the repo:
   ```bash
   git clone [https://github.com/nicoghezzi/zero-cost-idp-project.git](https://github.com/nicoghezzi/zero-cost-idp-project.git)

## 🚀 Author
Nicolas Ghezzi 
LinkedIn: https://www.linkedin.com/in/nghezzi/
