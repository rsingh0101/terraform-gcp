variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "subnet_cidr" {
  type = string
}
variable "network" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "tags" {
  type = list(string)
}

variable "metadata" {
  type = map(string)
}
variable "machine_type" {
  type = string
}
variable "instance_name" {
  type = string
}
variable "firewall_rules" {
  type = list(object({
    name          = string
    description   = optional(string)
    direction     = optional(string)
    priority      = optional(number)
    source_ranges = optional(list(string))
    target_tags   = optional(list(string))
    allowed       = list(object({
      protocol = string
      ports    = optional(list(string))
    }))
    denied = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])
  }))
}
