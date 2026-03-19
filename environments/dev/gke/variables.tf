variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP region to deploy resources (used as location)"
}

variable "cluster_name" {
  type        = string
  description = "Name of the GKE cluster"
}

variable "node_count" {
  type    = number
  default = 1
}

variable "machine_type" {
  type    = string
  default = "e2-micro"
}

variable "environment" {
  type        = string
  description = "Environment label (e.g., dev, prod)"
}

variable "network" {
  type        = string
  description = "The VPC network to host the cluster in"
  default     = "default"
}

variable "subnetwork" {
  type        = string
  description = "The subnetwork to host the cluster in"
  default     = "default"
}
