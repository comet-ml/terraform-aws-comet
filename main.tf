data "aws_eks_cluster_auth" "this" {
  count = var.enable_eks ? 1 : 0
  name  = module.comet_eks[0].cluster_name
}

locals {
  resource_name = "comet-${var.environment}"
  all_tags = merge(
    {
      Terraform   = "true"
    },
    var.environment_tag != "" ? { Environment = var.environment_tag } : {},
    var.common_tags
  )
}

module "comet_vpc" {
  source      = "./modules/comet_vpc"
  count       = var.enable_vpc ? 1 : 0
  environment = var.environment
  common_tags = local.all_tags
  region      = var.region
  vpc_cidr    = var.vpc_cidr

  eks_enabled        = var.enable_eks
  single_nat_gateway = var.single_nat_gateway
}

module "comet_ec2" {
  source      = "./modules/comet_ec2"
  count       = var.enable_ec2 ? 1 : 0
  environment = var.environment
  common_tags = local.all_tags

  vpc_id                   = var.enable_vpc ? module.comet_vpc[0].vpc_id : var.comet_vpc_id
  comet_ec2_subnet         = var.enable_vpc ? module.comet_vpc[0].public_subnets[0] : var.comet_public_subnets[0]
  comet_ec2_ami_type       = var.comet_ec2_ami_type
  comet_ec2_ami_id         = var.comet_ec2_ami_id
  comet_ec2_instance_type  = var.comet_ec2_instance_type
  comet_ec2_instance_count = var.comet_ec2_instance_count
  comet_ec2_volume_type    = var.comet_ec2_volume_type
  comet_ec2_volume_size    = var.comet_ec2_volume_size
  comet_ec2_key            = var.comet_ec2_key

  alb_enabled      = var.enable_ec2_alb
  comet_ec2_alb_sg = var.enable_ec2_alb ? module.comet_ec2_alb[0].comet_alb_sg : null

  s3_enabled              = var.enable_s3
  comet_ec2_s3_iam_policy = var.enable_s3 ? module.comet_s3[0].comet_s3_iam_policy_arn : null
}

module "comet_ec2_alb" {
  source      = "./modules/comet_ec2_alb"
  count       = var.enable_ec2_alb ? 1 : 0
  environment = var.environment
  common_tags = local.all_tags

  vpc_id              = var.enable_vpc ? module.comet_vpc[0].vpc_id : var.comet_vpc_id
  public_subnets      = var.enable_vpc ? module.comet_vpc[0].public_subnets : var.comet_public_subnets
  ssl_certificate_arn = var.enable_ec2_alb ? var.ssl_certificate_arn : null
}

module "comet_eks" {
  source      = "./modules/comet_eks"
  count       = var.enable_eks ? 1 : 0
  environment = var.environment
  common_tags = local.all_tags

  vpc_id                           = var.enable_vpc ? module.comet_vpc[0].vpc_id : var.comet_vpc_id
  eks_private_subnets              = var.enable_vpc ? module.comet_vpc[0].private_subnets : var.comet_private_subnets
  eks_cluster_name                 = var.eks_cluster_name
  eks_cluster_version              = var.eks_cluster_version
  eks_mng_ami_type                 = var.eks_mng_ami_type
  eks_mng_disk_size                = var.eks_mng_disk_size
  eks_aws_load_balancer_controller = var.eks_aws_load_balancer_controller
  eks_cert_manager                 = var.eks_cert_manager
  eks_aws_cloudwatch_metrics       = var.eks_aws_cloudwatch_metrics
  eks_external_dns                 = var.eks_external_dns
  eks_external_dns_r53_zones       = var.eks_external_dns_r53_zones

  s3_enabled              = var.enable_s3
  comet_ec2_s3_iam_policy = var.enable_s3 ? module.comet_s3[0].comet_s3_iam_policy_arn : null

  # MPM Infrastructure toggle
  enable_mpm_infra = var.enable_mpm_infra

  # Node Group Toggles
  enable_admin_node_group   = var.eks_enable_admin_node_group
  enable_comet_node_group   = var.eks_enable_comet_node_group
  enable_druid_node_group   = var.eks_enable_druid_node_group
  enable_airflow_node_group = var.eks_enable_airflow_node_group

  # Admin Node Group
  eks_admin_name           = var.eks_admin_name
  eks_admin_instance_types = var.eks_admin_instance_types
  eks_admin_min_size       = var.eks_admin_min_size
  eks_admin_max_size       = var.eks_admin_max_size
  eks_admin_desired_size   = var.eks_admin_desired_size

  # Comet Node Group
  eks_comet_name           = var.eks_comet_name
  eks_comet_instance_types = var.eks_comet_instance_types
  eks_comet_min_size       = var.eks_comet_min_size
  eks_comet_max_size       = var.eks_comet_max_size
  eks_comet_desired_size   = var.eks_comet_desired_size

  # Druid Node Group
  eks_druid_name           = var.eks_druid_name
  eks_druid_instance_types = var.eks_druid_instance_types
  eks_druid_min_size       = var.eks_druid_min_size
  eks_druid_max_size       = var.eks_druid_max_size
  eks_druid_desired_size   = var.eks_druid_desired_size

  # Airflow Node Group
  eks_airflow_name           = var.eks_airflow_name
  eks_airflow_instance_types = var.eks_airflow_instance_types
  eks_airflow_min_size       = var.eks_airflow_min_size
  eks_airflow_max_size       = var.eks_airflow_max_size
  eks_airflow_desired_size   = var.eks_airflow_desired_size

  # Additional custom node groups
  additional_node_groups = var.eks_additional_node_groups
}

module "comet_elasticache" {
  source      = "./modules/comet_elasticache"
  count       = var.enable_elasticache ? 1 : 0
  environment = var.environment
  common_tags = local.all_tags

  vpc_id                      = var.enable_vpc ? module.comet_vpc[0].vpc_id : var.comet_vpc_id
  elasticache_private_subnets = var.enable_vpc ? module.comet_vpc[0].private_subnets : var.comet_private_subnets
  elasticache_allow_from_sg = var.enable_ec2 ? module.comet_ec2[0].comet_ec2_sg_id : (
    var.enable_eks ? module.comet_eks[0].nodegroup_sg_id : (
  var.elasticache_allow_from_sg))
  elasticache_engine             = var.elasticache_engine
  elasticache_engine_version     = var.elasticache_engine_version
  elasticache_instance_type      = var.elasticache_instance_type
  elasticache_param_group_name   = var.elasticache_param_group_name
  elasticache_num_cache_nodes    = var.elasticache_num_cache_nodes
  elasticache_transit_encryption = var.elasticache_transit_encryption
  elasticache_auth_token         = var.elasticache_auth_token
}

module "comet_rds" {
  source      = "./modules/comet_rds"
  count       = var.enable_rds ? 1 : 0
  environment = var.environment
  common_tags = local.all_tags

  availability_zones  = var.enable_vpc ? module.comet_vpc[0].azs : var.availability_zones
  vpc_id              = var.enable_vpc ? module.comet_vpc[0].vpc_id : var.comet_vpc_id
  rds_private_subnets = var.enable_vpc ? module.comet_vpc[0].private_subnets : var.comet_private_subnets
  rds_allow_from_sg = var.enable_ec2 ? module.comet_ec2[0].comet_ec2_sg_id : (
    var.enable_eks ? module.comet_eks[0].nodegroup_sg_id : (
  var.rds_allow_from_sg))
  rds_engine                  = var.rds_engine
  rds_engine_version          = var.rds_engine_version
  rds_instance_type           = var.rds_instance_type
  rds_instance_count          = var.rds_instance_count
  rds_storage_encrypted       = var.rds_storage_encrypted
  rds_iam_db_auth             = var.rds_iam_db_auth
  rds_backup_retention_period = var.rds_backup_retention_period
  rds_preferred_backup_window = var.rds_preferred_backup_window
  rds_database_name           = var.rds_database_name
  rds_master_username         = var.rds_master_username
  rds_master_password         = var.rds_master_password
}

module "comet_s3" {
  source      = "./modules/comet_s3"
  count       = var.enable_s3 ? 1 : 0
  environment = var.environment
  common_tags = local.all_tags

  comet_s3_bucket  = var.s3_bucket_name
  s3_force_destroy = var.s3_force_destroy

  enable_mpm_infra = var.enable_mpm_infra
}
