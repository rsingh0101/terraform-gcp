variable "additional_disks" {
  type = list(object({
    name        = string
    size_gb     = number
    type        = string
  }))
}
variable "zone" {
  type = string
}
variable "project_id" {
  type = string
}
