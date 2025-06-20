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

variable "common_tags" {
  type        = map(string)
  description = "A map of common tags"
  default     = {}
}

variable "region" {
  description = "AWS region to provision resources in"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "private_subnet_tags" {
  type        = map(string)
  description = "A map of tags for private subnets"
  default     = {}
}
variable "public_subnet_tags" {
  type        = map(string)
  description = "A map of tags for public subnets"
  default     = {}
}
