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

  binary_authorization = {
    evaluation_mode = "PROJECT_SINGLETON_POLICY_ENFORCE"
  }

  enable_shielded_nodes = true

  master_auth = {
    client_certificate_config = { issue_client_certificate = false }
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
        resource_labels = { environment = "dev" }
        workload_metadata_config = {
          mode = "GKE_METADATA"
        }
        shielded_instance_config = {
          enable_secure_boot          = true
          enable_integrity_monitoring = true
        }
      }
    }
  ]
}
