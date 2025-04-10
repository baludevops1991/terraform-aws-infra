terraform-aws-arch/
│
├── .github/                         # CI/CD workflows (for GitHub Actions)
│   └── workflows/
│       ├── prod.yml                 # CI/CD pipeline for PROD
│       ├── uat.yml                  # CI/CD pipeline for UAT
│       └── global.yml               # CI/CD for global services (WAF, CF, etc.)
│
├── environments/                    # Separate folders per environment
│   ├── global/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   ├── outputs.tf
│   │   └── backend.tf
│   │
│   ├── prod/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   ├── outputs.tf
│   │   └── backend.tf
│   │
│   └── uat/
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       ├── outputs.tf
│       └── backend.tf
|
├── .gitignore
├── README.md
