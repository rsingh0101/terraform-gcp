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
  network                 = module.network.vpc_name
  subnetwork              = module.network.subnet_name
  tags                    = var.tags
  metadata                = var.metadata
  additional_disk_source = module.disk.disk_ids
}

module "network" {
  source = "../../../modules/network"

  project_id     = var.project_id
  region         = var.region
  vpc_name       = var.vpc_name
  subnet_cidr    = var.subnet_cidr
  subnetwork     = var.subnetwork
  enable_default_firewall = false
}

module "disk" {
  source           = "../../../modules/disks"
  project_id       = var.project_id
  zone             = var.zone
  additional_disk = var.additional_disk
}

module "firewall" {
  source     = "../../../modules/firewall"
  project_id = var.project_id
  network    = module.network.vpc_name
  rules      = var.firewall_rules
}
