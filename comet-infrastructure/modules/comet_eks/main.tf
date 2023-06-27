locals {
  tags = {
    Terraform   =  "true"
    Environment = var.environment
  }
}

data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.9"

  cluster_name                   = var.eks_cluster_name
  cluster_version                = var.eks_cluster_version
  cluster_endpoint_public_access = true
  
  vpc_id     = var.vpc_id
  subnet_ids = var.eks_private_subnets

  eks_managed_node_group_defaults = {ami_type = var.eks_mng_ami_type}

  eks_managed_node_groups = {
    one = {
      name           = var.eks_mng_name
      instance_types = var.eks_node_types
      min_size       = var.eks_mng_desired_size
      max_size       = var.eks_mng_max_size
      desired_size   = var.eks_mng_desired_size

      iam_role_additional_policies = var.s3_enabled ? {comet_s3_access = var.comet_ec2_s3_iam_policy} : {}
    }
  }

  tags = local.tags
}

module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "4.7.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

module "eks_blueprints_addons" {
  source = "aws-ia/eks-blueprints-addons/aws"
  version = "0.2.0"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  oidc_provider_arn = module.eks.oidc_provider_arn
  cluster_version   = module.eks.cluster_version

  eks_addons = {
    coredns            = {}
    vpc-cni            = {}
    kube-proxy         = {}
    aws-ebs-csi-driver = {service_account_role_arn = module.irsa-ebs-csi.iam_role_arn}
  }
  
  enable_aws_load_balancer_controller = var.eks_aws_load_balancer_controller
  enable_cert_manager                 = var.eks_cert_manager
  enable_aws_cloudwatch_metrics       = var.eks_aws_cloudwatch_metrics
  enable_external_dns                 = var.eks_external_dns

  tags = local.tags
}