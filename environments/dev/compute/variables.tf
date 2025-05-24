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
description = "Metadata key/value pairs"
type        = map(string)
default     = {}
}


