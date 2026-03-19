resource "google_sql_database_instance" "master" {
  name             = var.name
  project          = var.project_id
  region           = var.region
  database_version = var.database_version

  deletion_protection = var.deletion_protection

  settings {
    tier              = var.tier
    activation_policy = "ALWAYS"
    availability_type = var.availability_type
    disk_autoresize   = true
    disk_size         = var.disk_size
    disk_type         = var.disk_type

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_network_id
      ssl_mode        = "ENCRYPTED_ONLY"
    }

    backup_configuration {
      enabled                        = true
      start_time                     = var.backup_start_time
      point_in_time_recovery_enabled = true
    }

    maintenance_window {
      day  = var.maintenance_day
      hour = var.maintenance_hour
    }

    user_labels = var.labels

    database_flags {
      name  = "log_checkpoints"
      value = "on"
    }
    database_flags {
      name  = "log_connections"
      value = "on"
    }
    database_flags {
      name  = "log_disconnections"
      value = "on"
    }
    database_flags {
      name  = "log_lock_waits"
      value = "on"
    }
    database_flags {
      name  = "log_min_messages"
      value = "ERROR"
    }
    database_flags {
      name  = "log_hostname"
      value = "on"
    }
    database_flags {
      name  = "log_statement"
      value = "all"
    }
    database_flags {
      name  = "log_duration"
      value = "on"
    }
    database_flags {
      name  = "cloudsql.enable_pgaudit"
      value = "on"
    }
  }
}

resource "google_sql_database" "default" {
  name     = var.db_name
  project  = var.project_id
  instance = google_sql_database_instance.master.name
}

resource "google_sql_user" "users" {
  for_each = toset(var.user_names)

  name     = each.key
  instance = google_sql_database_instance.master.name
  password = var.user_password # In production, this should map to Secret Manager values, provided by the caller
}
