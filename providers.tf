provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = var.enable_eks ? module.comet_eks[0].cluster_endpoint : null
  cluster_ca_certificate = var.enable_eks ? base64decode(module.comet_eks[0].cluster_certificate_authority_data) : null
  token                  = var.enable_eks ? data.aws_eks_cluster_auth.this[0].token : null
}

provider "helm" {
  kubernetes {
    host                   = var.enable_eks ? module.comet_eks[0].cluster_endpoint : null
    cluster_ca_certificate = var.enable_eks ? base64decode(module.comet_eks[0].cluster_certificate_authority_data) : null
    token                  = var.enable_eks ? data.aws_eks_cluster_auth.this[0].token : null
  }
}