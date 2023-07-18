data "aws_availability_zones" "available" {}

locals {
  resource_name = "comet-${var.environment}"
  vpc_cidr      = "10.0.0.0/16"
  azs           = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0.0"

  name = "${local.resource_name}-vpc"
  cidr = local.vpc_cidr

  azs             = local.azs
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 10)]

  enable_nat_gateway   = true
  enable_dns_hostnames = true
  single_nat_gateway   = var.single_nat_gateway

  # Manage so we can name
  manage_default_network_acl    = true
  default_network_acl_tags      = { Name = "${local.resource_name}-default" }
  manage_default_route_table    = true
  default_route_table_tags      = { Name = "${local.resource_name}-default" }
  manage_default_security_group = true
  default_security_group_tags   = { Name = "${local.resource_name}-default" }

  # if EKS deployment, set subnet tags for AWS Load Balancer Controller auto-discovery
  public_subnet_tags  = var.eks_enabled ? {"kubernetes.io/role/elb" = 1} : null
  private_subnet_tags = var.eks_enabled ? {"kubernetes.io/role/internal-elb" = 1} : null

  tags = local.tags
}