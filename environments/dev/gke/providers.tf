data "google_client_config" "default" {}

data "google_container_cluster" "gke" {
  name     = module.gke.cluster_name
  location = var.region
  project  = var.project_id

  depends_on = [module.gke]
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.gke.endpoint}"

  token = data.google_client_config.default.access_token

  cluster_ca_certificate = base64decode(
    data.google_container_cluster.gke.master_auth[0].cluster_ca_certificate
  )
}