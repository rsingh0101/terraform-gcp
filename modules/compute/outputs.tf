output "instance_name" {
  value       = google_compute_instance.vm_instance.name
  description = "Name of the created VM instance"
}

output "instance_self_link" {
  value       = google_compute_instance.vm_instance.self_link
  description = "Self link of the VM instance"
}

output "instance_network_ip" {
  value       = google_compute_instance.vm_instance.network_interface[0].network_ip
  description = "Internal IP address"
}

output "instance_external_ip" {
  value       = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
  description = "External IP address"
}
