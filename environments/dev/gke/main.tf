provider "google" {
  project = var.project_id
  region  = var.region
}


module "firewall" {
  source     = "../../../modules/firewall"
  project_id = var.project_id
  network    = module.network.vpc_name
  depends_on = [module.network]
  rules = [
    {
      name          = "allow-ssh"
      description   = "Allow SSH from trusted IP"
      source_ranges = var.ssh_source_ranges

      allow = [
        {
          protocol = "tcp"
          ports    = ["22"]
        }
      ]
    },
    {
      name          = "allow-internal"
      priority      = 1000
      direction     = "INGRESS"
      source_ranges = ["10.0.0.0/8"]

      allow = [
        {
          protocol = "tcp"
        },
        {
          protocol = "udp"
        },
        {
          protocol = "icmp"
        }
      ]
    }
  ]
}

module "network" {
  source      = "../../../modules/network"
  project_id  = var.project_id
  region      = var.region
  subnetwork  = var.subnetwork
  subnet_cidr = var.subnetwork_cidr
  vpc_name    = var.vpc_name
  firewall_rules = var.firewall_rules
}

resource "google_compute_router" "router" {
  name    = "nat-router"
  network = module.network.vpc_name
  region  = var.region

  bgp {
    asn = 64514
  }
  depends_on = [module.network]
}

resource "google_compute_router_nat" "nat" {
  name                               = "nat-config"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  depends_on                         = [google_compute_router.router]
}


module "gke" {
  source     = "../../../modules/gke"
  project_id = var.project_id
  name       = var.cluster_name
  location   = var.region
  network    = module.network.vpc_name
  subnetwork = module.network.subnet_id
  remove_default_node_pool = true
  initial_node_count       = 1
  # master_authorized_networks_config = {
  #   cidr_blocks = [
  #     {
  #       display_name = "all"
  #       cidr_block   = "49.37.120.55/32"
  #     }
  #   ]
  #   # gcp_public_cidrs_access_enabled      = true
  #   private_endpoint_enforcement_enabled = false
  # }
  private_cluster_config = {
    enable_private_nodes    = true
    enable_private_endpoint = false
  }
  workload_identity_config = {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  binary_authorization = {
    evaluation_mode = "PROJECT_SINGLETON_POLICY_ENFORCE"
  }

  enable_shielded_nodes = true

  master_auth = {
    client_certificate_config = { issue_client_certificate = false }
  }

}

resource "google_container_node_pool" "primary_nodes" {
  name       = "dev-node-pool"
  location   = var.region
  cluster    = module.gke.cluster_name
  project    = var.project_id
  node_count = var.initial_node_count

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type = var.machine_type
    preemptible  = true
    
    # Shielded VM settings to satisfy other security checks
    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    # Best practice: use a specific service account instead of default
    # service_account = var.service_account 
    
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}