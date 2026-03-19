# Production-Grade Terraform for Google Cloud Platform (GCP)

[![Terraform Version](https://img.shields.io/badge/terraform-1.x-blue)](https://www.terraform.io)
[![CI/CD](https://github.com/rsingh0101/terraform-gcp/actions/workflows/terraform.yml/badge.svg)](https://github.com/rsingh0101/terraform-gcp/actions)

---

## Overview

This repository contains a fully-fledged, production-grade Infrastructure as Code (IaC) framework using **Terraform** for Google Cloud Platform (GCP). It is designed to be highly modular, secure by default, and scalable across multiple environments (e.g., `dev`, `staging`, `prod`).

The goal is to provide a standardized, DRY (Don't Repeat Yourself) setup complete with CI/CD integration, security scanning, and modern architecture patterns for GCP.

---

## Features

- **Standardized Environments**: Discrete `dev`, `staging`, and `prod` configurations ensuring strong isolation and reduced blast radius.
- **Production-Grade Modules**:
  - `gke`: Highly-configurable Kubernetes Engine clusters.
  - `compute`: Standardized Virtual Machines with disk attachments and networking.
  - `sql`: High-availability PostgreSQL deployments with automated private IP clustering, backups, and point-in-time recovery.
  - `storage`: Secured Google Cloud Storage buckets enforcing uniform bucket-level access, CMEK encryption, and IAM bindings.
  - `network`: VPCs, Subnets, and Firewall deployments.
- **Robust Security**: Integration with **Checkov** for static security scanning directly within the CI/CD pipeline.
- **CI/CD Built-In**: GitHub Actions workflow automatically formatting, validating, and scanning all changes on Pull Requests.
- **State Management**: Configured for remote state storage using centralized GCS backend (`backend.tf`).

---

## Repository Structure

```text
.
├── .github/
│   └── workflows/
│       └── terraform.yml          # GitHub Actions CI/CD Pipeline
├── environments/                  # Root Modules (Live environments)
│   ├── dev/
│   │   ├── compute/               # Dev Compute Engine Resources
│   │   └── gke/                   # Dev GKE Cluster 
│   ├── staging/
│   │   └── terraform.tfvars       # Staging Configurations
│   └── prod/
│       └── gke/                   # Production GKE + DB + Storage setup
└── modules/                       # Reusable child modules
    ├── compute/
    ├── disks/
    ├── gke/
    ├── network/
    ├── sql/
    └── storage/
```

---

## Getting Started

### Prerequisites

- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads) (version `1.x` recommended, specifically `>= 1.5.0`)
- [Google Cloud SDK (`gcloud`)](https://cloud.google.com/sdk/docs/install)
- A dedicated GCP project with proper IAM permissions (Compute Admin, Kubernetes Admin, Network Admin, Storage Admin).
- An existing GCS bucket to store the remote Terraform state (to be populated in `backend.tf`).

### Authentication Framework

It is recommended to use Workload Identity or impersonated Service Accounts. Alternatively, create a terraform service account:

```bash
./create-terraform-sa.sh <YOUR_PROJECT_ID>
export GOOGLE_APPLICATION_CREDENTIALS=".secrets/terraform-admin-key.json"
```

### Quick Deploy: Development Compute Instances

1. Clone this repository:
    ```bash
    git clone https://github.com/rsingh0101/terraform-gcp.git
    cd terraform-gcp/environments/dev/compute
    ```

2. Configure your Backend & Variables:
    - Update `backend.tf` to point to your Terraform bucket.
    - Copy the example variables file:
      ```bash
      cp terraform.tfvars.example terraform.tfvars
      ```
      *Update `terraform.tfvars` with your project and VPC details.*

3. Initialize and provision the infrastructure:
    ```bash
    terraform init -upgrade
    terraform plan -out=tfplan
    terraform apply tfplan
    ```

---

## Continuous Integration & Continuous Deployment (CI/CD)

This repository includes a GitHub Actions configuration `.github/workflows/terraform.yml`. On every PR or push to the `main` branch, the pipeline will:
1. Run `terraform fmt -check -recursive` to enforce standard formatting.
2. Execute **Checkov** to catch cloud misconfigurations and security issues before they are merged.
3. Help maintain the health of the repository modules.

---

## Contributing

Contributions are welcome! If you are adding a new module or environment:
1. Fork the repository.
2. Always ensure strict `versions.tf` boundaries (`>= 5.0, < 7.0` for Google provider).
3. Provide robust descriptions inside `variables.tf`.
4. Run `terraform fmt -recursive` locally before opening a pull request.
5. Create a feature branch and open a PR against `main`.

## Contact

Created and maintained by [rsingh0101](https://github.com/rsingh0101)  
For questions or support, open an issue or contact via GitHub.
