provider "google" {
  project = var.project_id
  region  = var.region
}

module "gke" {
  source     = "../../../modules/gke"
  project_id = var.project_id
  name       = var.cluster_name
  location   = var.region
  network    = var.network
  subnetwork = var.subnetwork

  master_authorized_networks_config = {
    cidr_blocks = [
      {
        display_name = "all"
        cidr_block   = "0.0.0.0/0"
      }
    ]
    gcp_public_cidrs_access_enabled      = true
    private_endpoint_enforcement_enabled = false
  }

  workload_identity_config = {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  node_pool = [
    {
      name               = "dev-node-pool"
      initial_node_count = var.node_count

      management = {
        auto_repair  = true
        auto_upgrade = true
      }

      node_config = {
        machine_type = var.machine_type
        disk_size_gb = 50
        disk_type    = "pd-standard"
        preemptible  = true
      }
    }
  ]
}
