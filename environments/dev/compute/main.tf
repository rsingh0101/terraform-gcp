provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

module "compute" {
  source                  = "../../../modules/compute"
  instance_name           = var.instance_name
  machine_type            = var.machine_type
  zone                    = var.zone
  project_id              = var.project_id
  network                 = var.network
  subnetwork              = var.subnetwork
  tags                    = var.tags
  metadata                = var.metadata
  additional_disks        = var.additional_disks
  additional_disk_sources = module.disks.disk_ids
}

module "network" {
  source = "../../../modules/network"

  project_id     = var.project_id
  region         = var.region
  vpc_name       = var.vpc_name
  subnet_cidr    = var.subnet_cidr
  subnetwork     = var.subnetwork
  firewall_rules = var.firewall_rules
}

module "disks" {
  source           = "../../../modules/disks"
  project_id       = var.project_id
  zone             = var.zone
  additional_disks = var.additional_disks
}