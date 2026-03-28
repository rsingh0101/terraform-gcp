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
  description = "List of firewall rules to create"
  type        = any # Or a more specific list(object) type
}