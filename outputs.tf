output "vpc_name" {
  value = module.network.vpc_name
}

output "instance_name" {
  value = module.compute.vm_name
}
