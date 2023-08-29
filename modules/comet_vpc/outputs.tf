output "azs" {
  description = "List of availability zones in the region"
  value       = module.vpc.azs
}

output "private_subnets" {
  description = "List of IDs for private subnets provisioned in the VPC"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs for public subnets provisioned in the VPC"
  value       = module.vpc.public_subnets
}

output "vpc_id" {
  description = "ID of the provisioned VPC"
  value       = module.vpc.vpc_id
}