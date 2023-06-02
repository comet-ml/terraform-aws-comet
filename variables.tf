variable "environment" {
  description = "Deployment environment, i.e. dev/stage/prod, etc"
  type        = string
  default     = "dev"
}

variable "enable_ec2_deployment" {
  description = "Toggles the ec2_deployment module, to provision EC2 resources for running Comet"
  type        = bool
}

variable "enable_eks_deployment" {
  description = "Toggles the ec2_deployment module, to provision EKS resources for running Comet"
  type        = bool
}

variable "enable_external_dependencies" {
  description = "Toggles the external_dependencies module, for provisioning ElasticCache Redis/RDS/S3"
  type        = bool
}

variable "region" {
  description = "AWS region to provision resources in"
  type        = string
  default     = "us-east-2"
}

variable "s3_bucket_name" {
  description = "Name for S3 bucket"
  type = string
  default = ""
}

variable "eks_cluster_name" {
  description = "Name for EKS cluster"
  type = string
  default = "cometeks"
}

variable "eks_cluster_version" {
  description = "Kubernetes version of the EKS cluster"
  type = string
  default = "1.24"
}