variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "region" {
  type        = string
  description = "GCP region"
  default = "us-central1"
}

variable "zone" {
  type        = string
  description = "GCP zone"
}

variable "instance_name" {
  type        = string
  description = "Name of the VM instance"
}

variable "machine_type" {
  type        = string
  description = "Machine type e.g. n1-standard-1"
  default     = "f2-micro"
}

variable "boot_disk_image" {
  type        = string
  description = "Boot disk image (e.g. projects/debian-cloud/global/images/family/debian-11)"
  default     = "projects/debian-cloud/global/images/family/debian-11"
}

variable "network" {
  type        = string
  description = "VPC network name"
}

variable "subnetwork" {
  type        = string
  description = "Subnetwork name"
  default     = null
}

variable "tags" {
  type        = list(string)
  description = "Network tags"
  default     = []
}

variable "metadata" {
  type        = map(string)
  description = "Metadata key-value pairs"
  default     = {}
}

variable "service_account_email" {
  type        = string
  description = "Service account email for the VM"
  default     = null
}

variable "scopes" {
  type        = list(string)
  description = "OAuth scopes for the VM"
  default     = ["https://www.googleapis.com/auth/cloud-platform"]
}

variable "can_ip_forward" {
  type        = bool
  description = "Whether to allow IP forwarding"
  default     = false
}

variable "preemptible" {
  type        = bool
  description = "Whether the VM is preemptible"
  default     = true
}

variable "automatic_restart" {
  type        = bool
  description = "Whether the VM should automatically restart"
  default     = false
}