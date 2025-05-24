variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "firewall_rules" {
  description = "List of firewall rules"
  type        = list(object({
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
