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
  description = "Name of subnet"
  type        = string
}

variable "firewall_rules" {
  description = "Optional firewall rules"
  type = list(object({
    name          = string
    protocol      = string
    ports         = list(string)
    source_ranges = list(string)
  }))
  default = []
}

variable "enable_default_firewall" {
  description = "Create default firewall rules"
  type        = bool
  default     = true
}
