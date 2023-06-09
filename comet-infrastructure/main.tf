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
    Terraform = "true"
    Environment       = var.environment
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0.0"

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
  public_subnet_tags  = var.enable_eks ? {"kubernetes.io/role/elb" = 1} : null
  private_subnet_tags = var.enable_eks ? {"kubernetes.io/role/internal-elb" = 1} : null

  tags = local.tags
}

module "comet_ec2" {
  source      = "./modules/comet_ec2"
  count       = var.enable_ec2 ? 1 : 0
  environment = var.environment
  
  vpc_id           = module.vpc.vpc_id
  comet_ec2_subnet = module.vpc.public_subnets[count.index % length(module.vpc.public_subnets)]

  comet_ec2_ami            = var.comet_ec2_ami
  comet_ec2_instance_type  = var.comet_ec2_instance_type
  comet_ec2_instance_count = var.comet_ec2_instance_count
  comet_ec2_volume_type    = var.comet_ec2_volume_type
  comet_ec2_volume_size    = var.comet_ec2_volume_size
  comet_ec2_key            = var.comet_ec2_key

  alb_enabled = var.enable_ec2_alb

  s3_enabled              = var.enable_s3
  comet_ml_s3_bucket      = var.s3_bucket_name
  comet_ec2_s3_iam_policy = var.enable_s3 ? module.comet_s3[0].comet_s3_iam_policy_arn : null
}

module "comet_ec2_alb" {
  source = "./modules/comet_ec2_alb"
  count  = var.enable_ec2_alb ? 1 : 0

  environment = var.environment

  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets

  ssl_certificate_arn = var.enable_ec2_alb ? var.ssl_certificate_arn : null
}

module "comet_eks" {
  source      = "./modules/comet_eks"
  count       = var.enable_eks ? 1 : 0
  environment = var.environment

  vpc_id                           = module.vpc.vpc_id
  eks_private_subnets              = module.vpc.private_subnets
  eks_cluster_name                 = var.eks_cluster_name
  eks_cluster_version              = var.eks_cluster_version
  eks_mng_name                     = var.eks_mng_name
  eks_mng_ami_type                 = var.eks_mng_ami_type
  eks_node_types                   = var.eks_node_types
  eks_mng_desired_size             = var.eks_mng_desired_size
  eks_mng_max_size                 = var.eks_mng_max_size
  eks_aws_load_balancer_controller = var.eks_aws_load_balancer_controller
  eks_cert_manager                 = var.eks_cert_manager
  eks_aws_cloudwatch_metrics       = var.eks_aws_cloudwatch_metrics
  eks_external_dns                 = var.eks_external_dns

  s3_enabled              = var.enable_s3
  comet_ec2_s3_iam_policy = var.enable_s3 ? module.comet_s3[0].comet_s3_iam_policy_arn : null
}

module "comet_elasticache" {
  source = "./modules/comet_elasticache"
  count  = var.enable_elasticache ? 1 : 0

  environment = var.environment

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

  environment = var.environment

  ec2_enabled = var.enable_ec2
  eks_enabled = var.enable_eks

  availability_zones = local.azs
  vpc_id              = module.vpc.vpc_id
  vpc_private_subnets = module.vpc.private_subnets

  # index is used on the module refs becuase of the count usage in the toggle: "After the count apply the resource becomes a group, so later in the reference use 0-index of the group"
  rds_allow_ec2_sg = var.enable_ec2 ? module.comet_ec2[0].comet_ec2_sg_id : null
  rds_allow_eks_sg = var.enable_eks ? module.comet_eks[0].nodegroup_sg_id : null

  rds_root_password = var.rds_root_password
}

module "comet_s3" {
  source = "./modules/comet_s3"
  count  = var.enable_s3 ? 1 : 0

  environment = var.environment

  comet_s3_bucket  = var.s3_bucket_name
}