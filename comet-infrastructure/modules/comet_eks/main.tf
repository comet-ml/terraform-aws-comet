locals {
  tags = {
    Terraform         =  "true"
    Environment       = var.environment
  }
}

data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.9"

  cluster_name                   = var.cluster_name
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = true
  
  vpc_id     = var.vpc_id
  subnet_ids = var.vpc_private_subnets

  #manage_aws_auth_configmap = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    one = {
      name = "mng"

      instance_types = ["m5.4xlarge"]

      min_size     = 3
      max_size     = 6
      desired_size = 3

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
    aws-ebs-csi-driver = {
      service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
    }
  }
  
  enable_aws_load_balancer_controller = true
  enable_cert_manager = true
  enable_aws_cloudwatch_metrics = true
  enable_external_dns = true

  tags = local.tags
}