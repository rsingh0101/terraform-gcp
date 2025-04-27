variable "project_id" {}
variable "zone" {}
variable "vm_name" {}
variable "vm_type" {}
variable "network" {}
variable "subnetwork" {
  description = "The subnetwork to attach the VM"
  type        = string
}

