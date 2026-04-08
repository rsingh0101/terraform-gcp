provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_route" "egress_internet" {
  name             = "egress-internet"
  dest_range       = "0.0.0.0/0"
  network          = module.network.vpc_name
  next_hop_gateway = "default-internet-gateway"
  priority         = 1000
}

module "firewall" {
  source     = "../../../modules/firewall"
  project_id = var.project_id
  network    = module.network.vpc_name
  rules      = var.firewall_rules
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
  master_authorized_networks_config = {
    cidr_blocks = [
      {
        display_name = "mylaptop"
        cidr_block   = var.ssh_source_ranges[0]
      }
    ]
    # gcp_public_cidrs_access_enabled      = true
    private_endpoint_enforcement_enabled = false
  }
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

locals {
  argocd_enable = var.enable_gke && var.enable_argocd
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

resource "helm_release" "argocd" {
  count = local.argocd_enable ? 1 : 0
  name  = "argocd"
  # repository = "https://argoproj.github.io/argo-helm"
  chart      = "../../../modules/helm/argo-cd"
  create_namespace = true
  namespace = "argocd"
  values = [ 
    file("../../../modules/helm/argo-cd/values.yaml") 
  ]
}