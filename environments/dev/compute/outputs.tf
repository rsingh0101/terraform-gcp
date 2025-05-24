output "instance_name" {
description = "Compute instance name"
value       = module.redis_compute.name
}

output "instance_zone" {
description = "Compute instance zone"
value       = var.zone
}

output "instance_ip" {
description = "External IP address of the instance"
value       = module.redis_compute.external_ip
}

