data "aws_eks_cluster_auth" "this" {
  count = var.enable_eks ? 1 : 0
  name  = module.comet_eks[0].cluster_name
}

data "aws_caller_identity" "current" {}

provider "aws" {
  region = var.region

  default_tags {
    tags = merge(
      {
        Terraform   = "true"
        Environment = var.environment_tag
      },
      var.common_tags
    )
  }
}

provider "kubernetes" {
  alias                  = "eks"
  host                   = var.enable_eks ? module.comet_eks[0].cluster_endpoint : null
  cluster_ca_certificate = var.enable_eks ? base64decode(module.comet_eks[0].cluster_certificate_authority_data) : null
  token                  = var.enable_eks ? data.aws_eks_cluster_auth.this[0].token : null
}

provider "helm" {
  alias = "eks"
  kubernetes {
    host                   = var.enable_eks ? module.comet_eks[0].cluster_endpoint : null
    cluster_ca_certificate = var.enable_eks ? base64decode(module.comet_eks[0].cluster_certificate_authority_data) : null
    token                  = var.enable_eks ? data.aws_eks_cluster_auth.this[0].token : null
  }
}