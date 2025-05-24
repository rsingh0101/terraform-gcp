output "instance_name" {
description = "Compute instance name"
value       = module.compute
}

output "instance_zone" {
description = "Compute instance zone"
value       = var.zone
}

output "instance_ip" {
description = "External IP address of the instance"
value       = module.compute.instance_external_ip
}

