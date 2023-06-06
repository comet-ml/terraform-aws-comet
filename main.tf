data "aws_availability_zones" "available" {}


data "aws_eks_cluster_auth" "this" {
  count = var.enable_eks ? 1 : 0
  name = module.comet_eks[0].cluster_name
}


locals {
  resource_name = "comet-${var.environment}"
  vpc_cidr      = "10.0.0.0/16"
  azs           = slice(data.aws_availability_zones.available.names, 0, 3)

  #set environment here, and use local.environment for the environment variables in all of the module calls

  tags = {
    Terraform_Managed = "true"
    Environment       = var.environment
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = local.resource_name
  cidr = local.vpc_cidr

  azs             = local.azs
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 10)]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  # Manage so we can name
  manage_default_network_acl    = true
  default_network_acl_tags      = { Name = "${local.resource_name}-default" }
  manage_default_route_table    = true
  default_route_table_tags      = { Name = "${local.resource_name}-default" }
  manage_default_security_group = true
  default_security_group_tags   = { Name = "${local.resource_name}-default" }

  # if EKS deployment, set subnet tags for AWS Load Balancer Controller auto-discovery
  public_subnet_tags = var.enable_eks ? {"kubernetes.io/role/elb" = 1} : null
  private_subnet_tags = var.enable_eks ? {"kubernetes.io/role/internal-elb" = 1} : null

  tags = local.tags
}

module "comet_ec2" {
  source = "./modules/comet_ec2"
  count  = var.enable_ec2 ? 1 : 0

  s3_enabled = var.enable_s3
  
  vpc_id = module.vpc.vpc_id
  comet_ec2_ami = "ami-05842f1afbf311a43"
  comet_ec2_subnet = module.vpc.public_subnets[count.index % length(module.vpc.public_subnets)]

  comet_ml_s3_bucket  = var.s3_bucket_name
}

module "comet_eks" {
  source = "./modules/comet_eks"
  count  = var.enable_eks ? 1 : 0

  vpc_id = module.vpc.vpc_id
  vpc_private_subnets = module.vpc.private_subnets
  cluster_name = var.eks_cluster_name
  cluster_version = var.eks_cluster_version
}

module "comet_elasticache" {
  source = "./modules/comet_elasticache"
  count  = var.enable_elasticache ? 1 : 0

  ec2_enabled = var.enable_ec2
  eks_enabled = var.enable_eks

  vpc_id              = module.vpc.vpc_id
  vpc_private_subnets = module.vpc.private_subnets

  # index is used on the module refs becuase of the count usage in the toggle: "After the count apply the resource becomes a group, so later in the reference use 0-index of the group"
  elasticache_allow_ec2_sg = var.enable_ec2 ? module.comet_ec2[0].comet_ec2_sg_id : null
  elasticache_allow_eks_sg = var.enable_eks ? module.comet_eks[0].nodegroup_sg_id : null
}

module "comet_rds" {
  source = "./modules/comet_rds"
  count  = var.enable_rds ? 1 : 0

  ec2_enabled = var.enable_ec2
  eks_enabled = var.enable_eks

  availability_zones = local.azs
  vpc_id              = module.vpc.vpc_id
  vpc_private_subnets = module.vpc.private_subnets

  # index is used on the module refs becuase of the count usage in the toggle: "After the count apply the resource becomes a group, so later in the reference use 0-index of the group"
  rds_allow_ec2_sg = var.enable_ec2 ? module.comet_ec2[0].comet_ec2_sg_id : null
  rds_allow_eks_sg = var.enable_eks ? module.comet_eks[0].nodegroup_sg_id : null
  
}

module "comet_s3" {
  source = "./modules/comet_s3"
  count  = var.enable_s3 ? 1 : 0

  comet_ml_s3_bucket  = var.s3_bucket_name
}