variable "environment" {
  description = "Deployment environment, i.e. dev/stage/prod, etc"
  type        = string
  default     = "dev"
}

variable "enable_ec2" {
  description = "Toggles the EC2 module, to provision EC2 resources for running Comet"
  type        = bool
}

variable "enable_eks" {
  description = "Toggles the EKS module, to provision EKS resources for running Comet"
  type        = bool
}

variable "enable_elasticache" {
  description = "Toggles the ElastiCache module for provisioning Comet Redis on ElastiCache"
  type        = bool
}

variable "enable_rds" {
  description = "Toggles the RDS module for provisioning Comet RDS database"
  type        = bool
}

variable "enable_s3" {
  description = "Toggles the S3 module for provisioning Comet S3 bucket"
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