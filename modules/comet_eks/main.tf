locals {
  volume_type = "gp3"
  volume_encrypted = false
  volume_delete_on_termination = true
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

  eks_managed_node_group_defaults = {
    ami_type = var.eks_mng_ami_type
    tags     = var.common_tags
    }

  eks_managed_node_groups = merge(
    {
      comet = {
        name           = var.eks_mng_name
        instance_types = var.eks_node_types
        min_size       = var.eks_mng_desired_size
        max_size       = var.eks_mng_max_size
        desired_size   = var.eks_mng_desired_size
        block_device_mappings = {
          xvda = {
            device_name = "/dev/xvda"
            ebs = {
              volume_size           = var.eks_mng_disk_size
              volume_type           = local.volume_type
              encrypted             = local.volume_encrypted
              delete_on_termination = local.volume_delete_on_termination
            }
          }
        }
        labels = {
          nodegroup_name = "comet"
        }
        tags = var.common_tags
        tags_propagate_at_launch = true
        launch_template_version = "$Latest"
        iam_role_additional_policies = var.s3_enabled ? { comet_s3_access = var.comet_ec2_s3_iam_policy } : {}
      }
    },
    var.enable_mpm_infra ? {
      druid = {
        name           = "druid"
        instance_types = [var.eks_druid_instance_type]
        min_size       = var.eks_druid_node_count
        max_size       = var.eks_druid_node_count
        desired_size   = var.eks_druid_node_count
        block_device_mappings = {
          xvda = {
            device_name = "/dev/xvda"
            ebs = {
              volume_size           = var.eks_mng_disk_size
              volume_type           = local.volume_type
              encrypted             = local.volume_encrypted
              delete_on_termination = local.volume_delete_on_termination
            }
          }
        }
        labels = {
          nodegroup_name = "druid"
        }
        tags     = var.common_tags
        tags_propogate_at_launch = true
        launch_template_version = "$Latest"
        iam_role_additional_policies = var.s3_enabled ? { comet_s3_access = var.comet_ec2_s3_iam_policy } : {}
      },
      airflow = {
        name           = "airflow"
        instance_types = [var.eks_airflow_instance_type]
        min_size       = var.eks_airflow_node_count
        max_size       = var.eks_airflow_node_count
        desired_size   = var.eks_airflow_node_count
        block_device_mappings = {
          xvda = {
            device_name = "/dev/xvda"
            ebs = {
              volume_size           = var.eks_mng_disk_size
              volume_type           = local.volume_type
              encrypted             = local.volume_encrypted
              delete_on_termination = local.volume_delete_on_termination
            }
          }
        }
        labels = {
          nodegroup_name = "airflow"
        }
        tags     = var.common_tags
        tags_propogate_at_launch = true
        launch_template_version = "$Latest"
        iam_role_additional_policies = var.s3_enabled ? { comet_s3_access = var.comet_ec2_s3_iam_policy } : {}
      }
    } : {}
  )
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
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "1.9.1"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  oidc_provider_arn = module.eks.oidc_provider_arn
  cluster_version   = module.eks.cluster_version

  eks_addons = {
    coredns            = {}
    vpc-cni            = {}
    kube-proxy         = {}
    aws-ebs-csi-driver = { service_account_role_arn = module.irsa-ebs-csi.iam_role_arn }
  }

  enable_aws_load_balancer_controller = var.eks_aws_load_balancer_controller
  enable_cert_manager                 = var.eks_cert_manager
  enable_aws_cloudwatch_metrics       = var.eks_aws_cloudwatch_metrics
  enable_external_dns                 = var.eks_external_dns
  external_dns_route53_zone_arns      = var.eks_external_dns_r53_zones
}