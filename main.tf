terraform {
    required_version = ">=1.3.0"
        backend "gcs" {
            bucket = "terraform-aqueous-scout-444117-j2"
                prefix = "global/state"
        }
}

provider "google" {
    project = var.project_id
        region  = var.region
}

module "network" {
    source      = "./modules/network/"
        project_id  = var.project_id
        region      = var.region
        vpc_name    = var.vpc_name
        subnet_cidr = var.subnet_cidr
}

module "compute" {
    source     = "./modules/compute/"
        project_id = var.project_id
        zone       = var.zone
        vm_name    = var.vm_name
        vm_type    = var.vm_type
        network    = module.network.vpc_name
        subnetwork = module.network.subnet_name
}

