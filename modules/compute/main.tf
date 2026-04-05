resource "google_compute_instance" "vm_instance" {
  name         = var.instance_name
  project      = var.project_id
  zone         = var.zone
  machine_type = var.machine_type
  metadata     = merge(var.metadata, { "block-project-ssh-keys" = "true" })
  tags         = var.tags

  boot_disk {
    initialize_params {
      image = var.boot_disk_image
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    access_config {
      # empty block = ephemeral public IP
    }
  }
  dynamic "attached_disk" {
    for_each = var.additional_disk_source
    content {
      device_name = attached_disk.key
      source      = attached_disk.value
      mode        = "READ_WRITE"
    }
  }

  service_account {
    email  = var.service_account_email
    scopes = var.scopes
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  scheduling {
    preemptible       = var.preemptible
    automatic_restart = var.automatic_restart
  }
}
