locals {
  tags = {
    Terraform_Managed = "true"
    Environment       = var.environment
  }
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

data "aws_iam_policy" "administrator_access" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.9"

  cluster_name                   = var.cluster_name
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
    }
    coredns = {}
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.vpc_private_subnets

  manage_aws_auth_configmap = true
  
  /* Remove additional IAM configuration for now; Enable later if warranted
  aws_auth_roles = [
    {
      rolearn  = aws_iam_role.eks_admin.arn
      username = "${aws_iam_role.eks_admin.name}"
      groups = [
        "system:masters"
      ]

    }
  ]
  */

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

module "eks_blueprints_kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons"

  eks_cluster_id       = module.eks.cluster_name
  eks_cluster_endpoint = module.eks.cluster_endpoint
  eks_oidc_provider    = module.eks.oidc_provider
  eks_cluster_version  = module.eks.cluster_version

  enable_cert_manager = true
  enable_aws_load_balancer_controller = true
  enable_aws_cloudwatch_metrics = true

  tags = local.tags
}

/* Remove additional IAM configuration for now; Enable later if warranted
resource "aws_iam_role" "eks_admin" {
  name = "admin-${var.cluster_name}"
  
  assume_role_policy = jsonencode({
  Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          "AWS": [
            "arn:aws:iam::897196112581:user/martinb"
          ]
        }
      },
    ]
  })
  
  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "eks_adminrole_policy_attach" {
  role       = "${aws_iam_role.eks_admin.name}"
  policy_arn = "${data.aws_iam_policy.administrator_access.arn}"
}
*/