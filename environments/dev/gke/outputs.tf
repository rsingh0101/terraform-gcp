output "vpc_name" {
  value = module.network.vpc_name
}

output "subnet_id" {
  value = module.network.subnet_id
}

output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = module.gke.cluster_name
}