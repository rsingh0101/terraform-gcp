provider "google" {
    project=var.project_id
        region=var.region
}

resource "google_container_cluster" "primary" {
    name=var.cluster_name
        location=var.region
        remove_default_node_pool=true
        initial_node_count=1
        networking_mode="VPC_NATIVE"
        ip_allocation_policy {}
}
resource "google_container_node_pool" "primary_nodes" {
    name       = "primary-node-pool"
        location   = var.region
        cluster    = google_container_cluster.primary.name
        node_count = var.node_count
        node_config {
            preemptible  = true
                machine_type = var.machine_type
                oauth_scopes = [
                "https://www.googleapis.com/auth/cloud-platform"
                ]
                labels = {
                    environment = var.environment
                }
            tags = ["gke-node"]
        }
}

