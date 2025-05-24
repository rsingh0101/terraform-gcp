output "cluster_name" {
value = google_container_cluster.primary.name
}
output "kubeconfig_command" {
value = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --region ${var.region} --project ${var.project_id}"
}

