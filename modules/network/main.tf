resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = var.vpc_name
  auto_create_subnetworks = false
  delete_default_routes_on_create = false
}

resource "google_compute_subnetwork" "subnet" {
  project                  = var.project_id
  name                     = var.subnetwork
  ip_cidr_range            = var.subnet_cidr
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_firewall" "default_deny_all" {
  name     = "${var.vpc_name}-default-deny-all"
  network  = google_compute_network.vpc.name
  project  = var.project_id
  priority = 65535
  direction = "INGRESS"

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}