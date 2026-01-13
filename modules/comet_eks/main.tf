locals {
  volume_type                  = "gp3"
  volume_encrypted             = false
  volume_delete_on_termination = true

  # Check if additional S3 bucket ARNs are provided
  has_additional_s3_buckets = var.additional_s3_bucket_arns != null && length(var.additional_s3_bucket_arns) > 0

  # Build the IAM policies map for node groups
  # Combines the comet S3 policy (if enabled) with additional S3 policy (if buckets provided)
  node_group_iam_policies = merge(
    var.s3_enabled ? { comet_s3_access = var.comet_ec2_s3_iam_policy } : {},
    local.has_additional_s3_buckets ? { additional_s3_access = aws_iam_policy.additional_s3_bucket_policy[0].arn } : {}
  )

  # Auto-generate security group rules for private access CIDRs
  private_access_sg_rules = var.eks_cluster_endpoint_private_access && length(var.eks_private_access_cidrs) > 0 ? {
    for idx, cidr in var.eks_private_access_cidrs : "private_access_${idx}" => {
      description = "Allow private access from ${cidr}"
      protocol    = "-1" # All protocols
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      cidr_blocks = [cidr]
    }
  } : {}

  # Merge auto-generated rules with any additional custom rules
  cluster_security_group_rules = merge(
    local.private_access_sg_rules,
    var.eks_cluster_security_group_additional_rules
  )

  # Build access entries for admin roles
  admin_access_entries = {
    for arn in var.eks_admin_role_arns : arn => {
      principal_arn = arn
      type          = "STANDARD"
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
}

data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# IAM policy for additional S3 bucket access (only created if additional_s3_bucket_arns is provided)
resource "aws_iam_policy" "additional_s3_bucket_policy" {
  count = local.has_additional_s3_buckets ? 1 : 0

  name        = "additional-s3-access-policy-${var.eks_cluster_name}"
  description = "Policy for access to additional S3 buckets from EKS cluster ${var.eks_cluster_name}"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:ListBucket*",
          "s3:PutBucket*",
          "s3:GetBucket*",
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts",
          "s3:ListBucketMultipartUploads"
        ],
        Resource = flatten([
          for arn in var.additional_s3_bucket_arns : [
            arn,
            "${arn}/*"
          ]
        ])
      }
    ]
  })
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31.6"

  cluster_name                    = var.eks_cluster_name
  cluster_version                 = var.eks_cluster_version
  cluster_endpoint_public_access  = var.eks_cluster_endpoint_public_access
  cluster_endpoint_private_access = var.eks_cluster_endpoint_private_access

  cluster_security_group_additional_rules = local.cluster_security_group_rules

  authentication_mode                         = var.eks_authentication_mode
  enable_cluster_creator_admin_permissions    = var.eks_enable_cluster_creator_admin_permissions

  access_entries = local.admin_access_entries

  vpc_id     = var.vpc_id
  subnet_ids = var.eks_private_subnets

  eks_managed_node_group_defaults = {
    ami_type = var.eks_mng_ami_type
    tags     = var.common_tags
    }

  eks_managed_node_groups = merge(
    # Admin Node Group
    var.enable_admin_node_group ? {
      admin = {
        name           = var.eks_admin_name
        instance_types = var.eks_admin_instance_types
        min_size       = var.eks_admin_min_size
        max_size       = var.eks_admin_max_size
        desired_size   = var.eks_admin_desired_size
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
          nodegroup_name = "admin"
        }
        tags                         = var.common_tags
        tags_propagate_at_launch     = true
        launch_template_version      = "$Latest"
        iam_role_additional_policies = local.node_group_iam_policies
      }
    } : {},
    # Comet Node Group
    var.enable_comet_node_group ? {
      comet = {
        name           = var.eks_comet_name
        instance_types = var.eks_comet_instance_types
        min_size       = var.eks_comet_min_size
        max_size       = var.eks_comet_max_size
        desired_size   = var.eks_comet_desired_size
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
        tags                         = var.common_tags
        tags_propagate_at_launch     = true
        launch_template_version      = "$Latest"
        iam_role_additional_policies = local.node_group_iam_policies
      }
    } : {},
    # Druid Node Group
    (var.enable_druid_node_group && var.enable_mpm_infra) ? {
      druid = {
        name           = var.eks_druid_name
        instance_types = var.eks_druid_instance_types
        min_size       = var.eks_druid_min_size
        max_size       = var.eks_druid_max_size
        desired_size   = var.eks_druid_desired_size
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
        tags                         = var.common_tags
        tags_propagate_at_launch     = true
        launch_template_version      = "$Latest"
        iam_role_additional_policies = local.node_group_iam_policies
      }
    } : {},
    # Airflow Node Group
    (var.enable_airflow_node_group && var.enable_mpm_infra) ? {
      airflow = {
        name           = var.eks_airflow_name
        instance_types = var.eks_airflow_instance_types
        min_size       = var.eks_airflow_min_size
        max_size       = var.eks_airflow_max_size
        desired_size   = var.eks_airflow_desired_size
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
        tags                         = var.common_tags
        tags_propagate_at_launch     = true
        launch_template_version      = "$Latest"
        iam_role_additional_policies = local.node_group_iam_policies
      }
    } : {},
    # ClickHouse Node Group
    var.enable_clickhouse_node_group ? {
      clickhouse = {
        name           = var.eks_clickhouse_name
        instance_types = var.eks_clickhouse_instance_types
        min_size       = var.eks_clickhouse_min_size
        max_size       = var.eks_clickhouse_max_size
        desired_size   = var.eks_clickhouse_desired_size
        block_device_mappings = {
          xvda = {
            device_name = "/dev/xvda"
            ebs = {
              volume_size           = var.eks_clickhouse_volume_size
              volume_type           = var.eks_clickhouse_volume_type
              encrypted             = var.eks_clickhouse_volume_encrypted
              delete_on_termination = var.eks_clickhouse_delete_on_termination
            }
          }
        }
        labels = {
          nodegroup_name = "clickhouse"
        }
        taints = [
          {
            key    = "clickhouse"
            value  = "true"
            effect = "NO_SCHEDULE"
          }
        ]
        tags                         = var.common_tags
        tags_propagate_at_launch     = true
        launch_template_version      = "$Latest"
        iam_role_additional_policies = local.node_group_iam_policies
      }
    } : {},
    # Additional custom node groups
    var.additional_node_groups
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

resource "kubernetes_storage_class" "gp3" {
  metadata {
    name = "gp3"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner = "ebs.csi.aws.com"

  parameters = {
    type = "gp3"
    # Optionally, set iops and throughput:
    # iops       = "3000"
    # throughput = "125"
  }

  reclaim_policy         = "Delete"
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true
}