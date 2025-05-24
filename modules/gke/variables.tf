variable "project_id" {
    description = "GCP project ID"
        type        = string
}

variable "region" {
    description = "GCP region to deploy GKE cluster"
        type        = string
        default     = "us-central1"  # Cheapest + widely available
}

variable "cluster_name" {
    description = "Name of the GKE cluster"
        type        = string
        default     = "my-gke-cluster"
}

variable "node_count" {
    description = "Number of nodes in the node pool"
        type        = number
        default     = 1  # Only 1 node to minimize cost
}

variable "machine_type" {
    description = "GCE machine type for cluster nodes"
        type        = string
        default     = "e2-micro"  # Cheapest eligible GKE VM (shared CPU)
}

variable "environment" {
    description = "Deployment environment (e.g., dev)"
        type        = string
        default     = "dev"
}

