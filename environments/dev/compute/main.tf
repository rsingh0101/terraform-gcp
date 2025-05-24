provider "google" {
project = var.project_id
region  = var.region
zone    = var.zone
}

module "redis_compute" {
source       = "../../modules/compute"

name         = var.instance_name
machine_type = var.machine_type
zone         = var.zone
project_id   = var.project_id

boot_disk_size_gb = var.boot_disk_size_gb
boot_disk_type    = var.boot_disk_type

network         = var.network
subnetwork      = var.subnetwork
tags            = var.tags
metadata        = var.metadata
}

