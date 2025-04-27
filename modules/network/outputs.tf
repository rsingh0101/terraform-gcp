output "vpc_name" {
    value = google_compute_network.vpc.name
}
output "subnet_name" { # Add this output for Compute module to use
  value = google_compute_subnetwork.subnet.name
}

