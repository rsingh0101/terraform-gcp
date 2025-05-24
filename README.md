# terraform-gcp

[![Terraform Version](https://img.shields.io/badge/terraform-1.x-blue)](https://www.terraform.io)  
[![License](https://img.shields.io/github/license/rsingh0101/terraform-gcp)](LICENSE)

---

## Overview

This repository contains Terraform configurations and reusable modules for provisioning infrastructure on **Google Cloud Platform (GCP)**. It supports managing various resources like Compute Engine instances, GKE clusters, networking, and more — organized for multiple projects and environments.

The goal is to provide a modular, scalable, and maintainable infrastructure-as-code framework that can be customized and extended for different GCP use cases.

---

---

## Features

- Modular Terraform code for reusable infrastructure components  
- Environment-specific configuration support (dev, staging, prod)  
- Supports Compute Engine VM provisioning (e.g., Redis benchmarking server)  
- Supports GKE cluster provisioning  
- Networking modules for VPC, subnets, firewall rules, etc.  
- Uses GCP recommended best practices and Terraform modules  
- Designed for easy CI/CD integration and automation  

---

## Getting Started

### Prerequisites

- [Terraform CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli) (version 1.x recommended)  
- [Google Cloud SDK (`gcloud`)](https://cloud.google.com/sdk/docs/install)  
- A GCP project with proper permissions for Terraform (Compute Admin, Kubernetes Admin, Network Admin, etc.)  
- Service Account key JSON file (recommended for authentication)  

---

### Quickstart Example: Deploy Compute Engine VM

1. Clone this repo:

    ```bash
    git clone https://github.com/rsingh0101/terraform-gcp.git
    cd terraform-gcp/projects/projectA/environments/dev/compute
    ```

2. Initialize Terraform:

    ```bash
    terraform init
    ```

3. Review variables in `terraform.tfvars` and adjust as needed.

4. Apply the configuration:

    ```bash
    terraform apply -var-file=terraform.tfvars
    ```

5. Confirm resources are created in your GCP project.

---

## How to Use

- Customize variables for each environment under `projects/<project-name>/environments/<env>/terraform.tfvars`  
- Add or update Terraform modules in `modules/`  
- Use Terraform workspaces if you want to share state across environments  
- Run Terraform commands (`init`, `plan`, `apply`, `destroy`) from environment directories to target specific infra  

---

## Contributing

Contributions are welcome! Please:

- Fork the repository  
- Create a feature branch  
- Open a pull request with a detailed description  

---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

---

## Contact

Created and maintained by [rsingh0101](https://github.com/rsingh0101).  
For questions or support, open an issue or contact via GitHub.

