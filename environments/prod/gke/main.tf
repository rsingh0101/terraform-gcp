# google_client_config and kubernetes provider must be explicitly specified like the following.
data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source                     = "../../../modules/gke"
  project_id                 = "<PROJECT ID>"
  name                       = "gke-test-1"
  region                     = "us-central1"
  zones                      = ["us-central1-a", "us-central1-b", "us-central1-f"]
  network                    = "vpc-01"
  subnetwork                 = "us-central1-01"
  ip_range_pods              = "us-central1-01-gke-01-pods"
  ip_range_services          = "us-central1-01-gke-01-services"
  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  enable_private_endpoint    = true
  enable_private_nodes       = true
  cloudrun                   = true
  dns_cache                  = false

  node_pools = [
    {
      name                       = "default-node-pool"
      machine_type               = "e2-medium"
      node_locations             = "us-central1-b,us-central1-c"
      min_count                  = 1
      max_count                  = 100
      local_ssd_count            = 0
      spot                       = false
      local_ssd_ephemeral_count  = 0
      disk_size_gb               = 100
      disk_type                  = "pd-standard"
      image_type                 = "COS_CONTAINERD"
      enable_gcfs                = false
      enable_gvnic               = false
      logging_variant            = "DEFAULT"
      auto_repair                = true
      auto_upgrade               = true
      service_account            = "project-service-account@<PROJECT ID>.iam.gserviceaccount.com"
      preemptible                = false
      initial_node_count         = 80
      accelerator_count          = 1
      accelerator_type           = "nvidia-l4"
      gpu_driver_version         = "LATEST"
      gpu_sharing_strategy       = "TIME_SHARING"
      max_shared_clients_per_gpu = 2
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
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