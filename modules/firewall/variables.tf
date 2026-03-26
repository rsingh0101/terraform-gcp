variable "project_id" {
  type = string
}

variable "network" {
  description = "VPC network name or self_link"
  type        = string
}

variable "rules" {
  description = "List of firewall rules"
  type = list(object({
    name        = string
    description = optional(string)
    direction   = optional(string, "INGRESS")
    priority    = optional(number, 1000)

    source_ranges      = optional(list(string), [])
    destination_ranges = optional(list(string), [])
    target_tags        = optional(list(string), [])

    allow = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])

    deny = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])
  }))
}