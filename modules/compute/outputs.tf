output "vm_name" {
  description = "The name of the VM instance"
  value       = google_compute_instance.vm.name
}

output "vm_zone" {
  description = "The zone where the VM is deployed"
  value       = google_compute_instance.vm.zone
}

output "vm_public_ip" {
  description = "The public IP address of the VM"
  value       = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}

output "vm_private_ip" {
  description = "The private IP address of the VM"
  value       = google_compute_instance.vm.network_interface[0].network_ip
}

