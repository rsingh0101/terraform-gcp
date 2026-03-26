output "vpc_name" {
  value = google_compute_network.vpc.name
}
output "vpc_id" {
  value = google_compute_network.vpc.id
}
output "subnet_name" { # Add this output for Compute module to use
  value = google_compute_subnetwork.subnet.name
}

output "subnet_id" {
  value = google_compute_subnetwork.subnet.id
}