variable "project_id" {
  description = "The ID of the GCP project where resources will be created."
  type        = string
}

variable "region" {
  description = "The default GCP region for the resources."
  type        = string
}

variable "zone" {
  description = "The default GCP zone for the compute resources."
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC network to create."
  type        = string
}

variable "subnet_cidr" {
  description = "The CIDR block for the subnetwork."
  type        = string
}

variable "network" {
  description = "The network to attach to the compute instance."
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork to attach to the compute instance."
  type        = string
}

variable "tags" {
  description = "A list of network tags to attach to the instance."
  type        = list(string)
}

variable "metadata" {
  description = "Metadata key/value pairs to make available from within the instance."
  type        = map(string)
}

variable "machine_type" {
  description = "The machine type to create."
  type        = string
}

variable "instance_name" {
  description = "The name of the compute instance."
  type        = string
}

variable "firewall_rules" {
  description = "List of firewall rules to apply to the network."
  type = list(object({
    name          = string
    description   = optional(string)
    direction     = optional(string)
    priority      = optional(number)
    source_ranges = optional(list(string))
    target_tags   = optional(list(string))
    allowed = list(object({
      protocol = string
      ports    = optional(list(string))
    }))
    denied = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])
  }))
}

variable "additional_disks" {
  description = "List of additional persistent disks to attach to the instance."
  type = list(object({
    name        = string
    size_gb     = number
    type        = string
    device_name = string
    auto_delete = bool
  }))
}
