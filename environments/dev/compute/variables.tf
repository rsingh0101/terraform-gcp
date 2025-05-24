variable "project_id" {
description = "GCP project ID"
type        = string
}

variable "region" {
description = "GCP region"
type        = string
default     = "us-central1"
}

variable "zone" {
description = "GCP zone"
type        = string
default     = "us-central1-a"
}

variable "instance_name" {
description = "Name of the Compute Engine instance"
type        = string
default     = "redis-benchmark-vm"
}

variable "machine_type" {
description = "Machine type"
type        = string
default     = "e2-medium"
}

variable "boot_disk_size_gb" {
description = "Boot disk size in GB"
type        = number
default     = 20
}

variable "boot_disk_type" {
description = "Boot disk type"
type        = string
default     = "pd-balanced"
}

variable "network" {
description = "VPC network name"
type        = string
default     = "default"
}

variable "subnetwork" {
description = "Subnetwork name"
type        = string
default     = ""
}

variable "tags" {
description = "Network tags"
type        = list(string)
default     = ["redis", "benchmark"]
}

variable "metadata" {
  type = map(string)
  default = {
    "startup-script" = <<-EOF
      #!/bin/bash
      apt-get update
      apt-get install -y docker.io docker-compose git
      systemctl start docker
      systemctl enable docker

      # Pull docker-compose and other config files (example: from GitHub)
      git clone https://github.com/youruser/yourrepo.git /opt/redis-benchmark

      cd /scripts/redis_benchmark
      docker-compose up -d
    EOF
  }
}



