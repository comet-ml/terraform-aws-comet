locals {
  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Terraform = "true",
    Environment = var.environment
  } 
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = var.cluster_name
  cidr = local.vpc_cidr

  azs             = local.azs
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 10)]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  # Manage so we can name
  manage_default_network_acl    = true
  default_network_acl_tags      = { Name = "${var.cluster_name}-default" }
  manage_default_route_table    = true
  default_route_table_tags      = { Name = "${var.cluster_name}-default" }
  manage_default_security_group = true
  default_security_group_tags   = { Name = "${var.cluster_name}-default" }

  # need conditional application of below subnet tags; if not using eks, tags unnecessary
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    # Tags subnets for Karpenter auto-discovery
    "karpenter.sh/discovery" = var.cluster_name
  }

  tags = local.tags
}

module "ec2_deployment" {
  source = "./modules/ec2_deployment"
  count = var.enable_ec2_deployment ? 1 : 0
}

module "eks_deployment" {
  source = "./modules/eks_deployment"
  count = var.enable_eks_deployment ? 1 : 0
}

module "external_dependencies" {
  source = "./modules/external_dependencies"
  count = var.enable_external_dependencies ? 1 : 0

  vpc_id = module.vpc.vpc_id
  vpc_private_subnets = module.vpc.private_subnets
}