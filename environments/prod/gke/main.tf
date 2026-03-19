# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source         = "../../../modules/gke"
  project_id     = "<PROJECT ID>"
  name           = "gke-test-1"
  location       = "us-central1"
  node_locations = ["us-central1-a", "us-central1-b", "us-central1-f"]
  network        = "vpc-01"
  subnetwork     = "us-central1-01"

  # IP Allocation Policy for Pods and Services
  ip_allocation_policy = {
    cluster_secondary_range_name  = "us-central1-01-gke-01-pods"
    services_secondary_range_name = "us-central1-01-gke-01-services"
  }

  master_authorized_networks_config = {
    cidr_blocks                     = []
    gcp_public_cidrs_access_enabled = false
  }

  workload_identity_config = {
    workload_pool = "<PROJECT ID>.svc.id.goog"
  }

  binary_authorization = {
    evaluation_mode = "PROJECT_SINGLETON_POLICY_ENFORCE"
  }

  enable_shielded_nodes = true

  master_auth = {
    client_certificate_config = { issue_client_certificate = false }
  }

  addons_config = {
    http_load_balancing             = { disabled = true }
    horizontal_pod_autoscaling      = { disabled = false }
    gcp_filestore_csi_driver_config = { enabled = false }
    dns_cache_config                = { enabled = false }
  }

  node_pool = [
    {
      name               = "default-node-pool"
      initial_node_count = 80
      node_locations     = ["us-central1-b", "us-central1-c"]

      autoscaling = {
        min_node_count = 1
        max_node_count = 100
      }

      management = {
        auto_repair  = true
        auto_upgrade = true
      }

      node_config = {
        machine_type    = "e2-medium"
        image_type      = "COS_CONTAINERD"
        disk_size_gb    = 100
        disk_type       = "pd-standard"
        service_account = "project-service-account@<PROJECT ID>.iam.gserviceaccount.com"
        preemptible     = false
        tags            = ["default-node-pool"]
        labels          = { default-node-pool = "true" }
        resource_labels = { environment = "prod" }
        workload_metadata_config = {
          mode = "GKE_METADATA"
        }
        shielded_instance_config = {
          enable_secure_boot          = true
          enable_integrity_monitoring = true
        }
        metadata = { node-pool-metadata-custom-value = "my-node-pool" }
        taint = [
          {
            key    = "default-node-pool"
            value  = "true"
            effect = "PREFER_NO_SCHEDULE"
          }
        ]
        guest_accelerator = {
          type  = "nvidia-l4"
          count = 1
          gpu_sharing_config = {
            gpu_sharing_strategy       = "TIME_SHARING"
            max_shared_clients_per_gpu = 2
          }
          gpu_driver_installation_config = {
            gpu_driver_version = "LATEST"
          }
        }
      }
    }
  ]
}

module "app_storage" {
  source = "../../../modules/storage"

  project_id = "<PROJECT ID>"
  name       = "prod-app-storage-bucket-q2xk"
  location   = "US"
  versioning = true

  iam_bindings = {
    "roles/storage.objectViewer" = [
      "serviceAccount:project-service-account@<PROJECT ID>.iam.gserviceaccount.com"
    ]
  }
}

module "app_database" {
  source = "../../../modules/sql"

  project_id          = "<PROJECT ID>"
  name                = "prod-postgres-db"
  region              = "us-central1"
  database_version    = "POSTGRES_14"
  availability_type   = "REGIONAL"
  vpc_network_id      = "projects/<PROJECT ID>/global/networks/vpc-01" # This must match your actual VPC self-link
  user_password       = "dummy-pass-replace-with-secret-manager"
  deletion_protection = false # Note: Set to true in real production
}