provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = module.eks_deployment[0].cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_deployment[0].cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks_deployment[0].cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_deployment[0].cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}