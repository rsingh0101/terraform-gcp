terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0, < 7.0"
    }
  }
}


resource "firewall" "rke2" {
    source = "../../../modules/firewall"
    allow_ports = [6443, 9345, 10250, 8472, 4240]
    network     = module.vpc.network
}
resource "compute" "rke2" {
    source = "../../../modules/compute"   
}

resource "vpc" "rke2" {
    source = "../../../modules/vpc"
    vpc_name=var.vpc_name
}

resource "disks" "rke2" {
    source = "../../../modules/disks"
}
