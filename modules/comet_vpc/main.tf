data "aws_availability_zones" "available" {}

locals {
  resource_name = "comet-${var.environment}"
  vpc_cidr      = var.vpc_cidr
  azs           = slice(data.aws_availability_zones.available.names, 0, 3)
  # if EKS deployment, set subnet tags for AWS Load Balancer Controller auto-discovery
  public_subnet_tags  = var.eks_enabled ? { "kubernetes.io/role/elb" = "1" } : {}
  private_subnet_tags = var.eks_enabled ? { "kubernetes.io/role/internal-elb" = "1" } : {}
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0.0"

  name = "${local.resource_name}-vpc"
  cidr = local.vpc_cidr

  azs             = local.azs
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 5, 3 * k + 1)]

  enable_nat_gateway   = true
  enable_dns_hostnames = true
  single_nat_gateway   = var.single_nat_gateway

  # Manage so we can name
  manage_default_network_acl    = true
  default_network_acl_tags      = merge(var.common_tags, { Name = "${local.resource_name}-default" })
  manage_default_route_table    = true
  default_route_table_tags      = merge(var.common_tags, { Name = "${local.resource_name}-default" })
  manage_default_security_group = true
  default_security_group_tags   = merge(var.common_tags, { Name = "${local.resource_name}-default" })

  public_subnet_tags = merge(
    local.public_subnet_tags,
    var.public_subnet_tags,
  )
  private_subnet_tags = merge(
    local.private_subnet_tags,
    var.private_subnet_tags,
  )
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = concat(module.vpc.private_route_table_ids, module.vpc.public_route_table_ids)
  tags = merge(
    var.common_tags,
    { Name = "${local.resource_name}-s3-endpoint" }
  )
}
