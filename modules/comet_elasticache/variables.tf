variable "environment" {
  description = "Deployment environment, i.e. dev/stage/prod, etc"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC that will contain the provisioned resources"
  type        = string
}

variable "elasticache_private_subnets" {
  description = "IDs of private subnets within the VPC"
  type        = list(string)
}

variable "elasticache_allow_from_sg" {
  description = "Security group from which connections to ElastiCache will be allowed"
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

variable "elasticache_transit_encryption" {
  description = "Enable transit encryption for ElastiCache"
  type        = bool
}

variable "elasticache_automatic_failover_enabled" {
  description = "Enable automatic failover for the ElastiCache replication group. Requires at least one replica (elasticache_num_cache_nodes >= 2)."
  type        = bool
  default     = false
}

variable "elasticache_multi_az_enabled" {
  description = "Enable Multi-AZ for the ElastiCache replication group. Requires automatic_failover to also be enabled and at least one replica in a different AZ."
  type        = bool
  default     = false
}

variable "elasticache_auth_token" {
  description = "Auth token for ElastiCache"
  type        = string
  default     = null
}

variable "common_tags" {
  type        = map(string)
  description = "A map of common tags"
  default     = {}
}
