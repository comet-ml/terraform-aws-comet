variable "environment" {
  description = "Deployment environment, i.e. dev/stage/prod, etc"
  type        = string
  default     = "dev"
}

variable "vpc_id" {
  description = "ID of the VPC that will contain the provisioned resources"
  type        = string
}

variable "elasticache_private_subnets" {
  description = "IDs of private subnets within the VPC"
  type        = list(string)
}

variable "elasticache_allow_ec2_sg" {
  description = "Security group associated with EC2 compute, if provisioned"
  type        = string
}

variable "elasticache_allow_eks_sg" {
  description = "Security group associated with EKS compute, if provisioned"
  type        = string
}

variable "elasticache_engine" {
  description = "Engine type for Elasticache cluster"
  type        = string
}

variable "elasticache_engine_version" {
  description = "Version number for Elasticache engine"
  type        = string
}

variable "elasticache_instance_type" {
  description = "Elasticache instance type"
  type        = string
}

variable "elasticache_param_group_name" {
  description = "Name for the Elasticache cluster parameter group"
  type        = string
}

variable "elasticache_num_cache_nodes" {
  description = "Number of nodes in the Elasticache cluster"
  type        = number
}

variable "ec2_enabled" {
  description = "Indicates if EC2 compute has been provisioned for Comet"
  type        = bool
  default     = null
}

variable "eks_enabled" {
  description = "Indicates if EKS compute has been provisioned for Comet"
  type        = bool
  default     = null
}