variable "environment" {
  description = "Deployment environment, i.e. dev/stage/prod, etc"
  type        = string
  default     = "dev"
}

variable "elasticache_redis_instance_type" {
  description = "Elasticache Redis instance type"
  type        = string
  default     = "cache.r4.xlarge"
}

variable "elasticache_engine" {
  description = "Engine type for Elasticache cluster"
  type        = string
  default     = "redis"
}

variable "elasticache_engine_version" {
  description = "Version number for Elasticache engine"
  type        = string
  default     = "5.0.6"
}

variable "elasticache_param_group_name" {
  description = "Name for the Elasticache cluster parameter group"
  type        = string
  default     = "default.redis5.0"
}

variable "elasticache_num_cache_nodes" {
  description = "Number of nodes in the Elasticache cluster"
  type        = number
  default     = 1
}

variable "vpc_id" {
  description = "ID of the VPC that will contain the provisioned resources"
  type        = string
  default     = ""
}

variable "vpc_private_subnets" {
  description = "IDs of private subnets within the VPC"
  type        = list(string)
  default     = []
}

variable "elasticache_rds_allowfrom_sg" {
  description = "Security group(s) attached to the Comet instance(s); Specified in the ingress allow rules on the Elasticache and RDS security groups"
  type        = string
  default     = ""
}