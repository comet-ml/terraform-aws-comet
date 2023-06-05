data "aws_availability_zones" "available" {}

/*
data "aws_eks_cluster_auth" "this" {
  name = module.eks_deployment[0].cluster_name
}
*/

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
  public_subnet_tags = var.enable_eks_deployment ? {"kubernetes.io/role/elb" = 1} : null
  private_subnet_tags = var.enable_eks_deployment ? {"kubernetes.io/role/internal-elb" = 1} : null

  tags = local.tags
}

module "ec2_deployment" {
  source = "./modules/ec2_deployment"
  count  = var.enable_ec2_deployment ? 1 : 0
  
  vpc_id = module.vpc.vpc_id
  allinone_ami = "ami-05842f1afbf311a43"
  allinone_subnet = module.vpc.public_subnets[count.index % length(module.vpc.public_subnets)]

  comet_ml_s3_bucket  = var.s3_bucket_name
}

module "eks_deployment" {
  source = "./modules/eks_deployment"
  count  = var.enable_eks_deployment ? 1 : 0

  vpc_id = module.vpc.vpc_id
  vpc_private_subnets = module.vpc.private_subnets
  cluster_name = var.eks_cluster_name
  cluster_version = var.eks_cluster_version
}

/*
module "external_dependencies" {
  source = "./modules/external_dependencies"
  count  = var.enable_external_dependencies ? 1 : 0

  availability_zones = local.azs
  vpc_id              = module.vpc.vpc_id
  vpc_private_subnets = module.vpc.private_subnets

  comet_ml_s3_bucket  = var.s3_bucket_name

  elasticache_rds_allowfrom_sg = module.ec2_deployment[0].allinone_sg_id
}
*/

module "comet_elasticache" {
  source = "./modules/comet_elasticache"
  count  = var.enable_elasticache ? 1 : 0

  vpc_id              = module.vpc.vpc_id
  vpc_private_subnets = module.vpc.private_subnets

  # need to get SGs from ec2_deployment or eks_deployment, depending on which is used
  # index is used on the ec2_deployment becuase of the count usage in the toggle: "After the count apply the resource becomes a group, so later in the reference use 0-index of the group"
  elasticache_rds_allowfrom_sg = module.ec2_deployment[0].allinone_sg_id
}

module "comet_rds" {
  source = "./modules/comet_rds"
  count  = var.enable_rds ? 1 : 0

  availability_zones = local.azs
  vpc_id              = module.vpc.vpc_id
  vpc_private_subnets = module.vpc.private_subnets

  # need to get SGs from ec2_deployment or eks_deployment, depending on which is used
  # index is used on the ec2_deployment becuase of the count usage in the toggle: "After the count apply the resource becomes a group, so later in the reference use 0-index of the group"
  elasticache_rds_allowfrom_sg = module.ec2_deployment[0].allinone_sg_id
  
}

module "comet_s3" {
  source = "./modules/comet_s3"
  count  = var.enable_s3 ? 1 : 0

  comet_ml_s3_bucket  = var.s3_bucket_name
}