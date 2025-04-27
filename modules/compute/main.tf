resource "google_compute_instance" "vm" {
  name         = var.vm_name
  machine_type = var.vm_type
  zone         = var.zone
  project      = var.project_id

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 20 # Default disk size in GB
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork # Explicitly specify subnetwork
    access_config {} # Assigns an external IP
  }
}

