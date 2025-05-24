resource "google_compute_instance" "vm_instance" {
  name         = var.instance_name
  project      = var.project_id
  zone         = var.zone
  machine_type = var.machine_type
  metadata = var.metadata
  tags = var.tags

  boot_disk {
    initialize_params {
      image = var.boot_disk_image
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    access_config {}
  }

  service_account {
    email  = var.service_account_email
    scopes = var.scopes
  }

  scheduling {
    preemptible = var.preemptible
    automatic_restart= var.automatic_restart
  }
}
