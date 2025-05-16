variable "environment" {
  description = "Deployment environment, i.e. dev/stage/prod, etc"
  type        = string
}

variable "eks_enabled" {
  description = "Indicates if EKS module enabled"
  type        = bool
}

variable "single_nat_gateway" {
  description = "Controls whether single NAT gateway used for all public subnets"
  type        = bool
}

variable "region" {
  description = "AWS region to provision resources in"
  type        = string
}