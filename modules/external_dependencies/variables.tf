variable "environment" {
  description = "Deployment environment, i.e. dev/stage/prod, etcs"
  type        = string
  default     = "dev"
}

variable "elasticache_redis_instance_type" {
  description = "ElasticCache Redis instance type"
  type        = string
  default     = "cache.r4.xlarge"
}

variable "elasticcache_engine" {
  description = "Engine type for ElasticCache cluster"
  type        = string
  default     = "redis"
}

variable "elasticcache_engine_version" {
  description = "Version number for ElasticCache engine"
  type        = string
  default     = "5.0.6"
}

variable "elasticcache_param_group_name" {
  description = "Name for the ElasticCache cluster parameter group"
  type        = string
  default     = "default.redis5.0"
}

variable "elasticcache_num_cache_nodes" {
  description = "Number of nodes in the ElasticCache cluster"
  type        = number
  default     = 1
}

variable "comet_ml_s3_bucket" {}

variable "rds_root_password" {
  description = "Root password for RDS database"
  type        = string
  default     = "rdsVN1y74dbNb47MyiPp3wxXHwAPez"
}

variable "rds_instance_type" {
  description = "Instance type for RDS database"
  type        = string
  default     = "db.r5.xlarge"
}

variable "rds_instance_count" {
  description = "Number of RDS instances in the database cluster"
  type        = number
  default     = 2
}

variable "rds_engine" {
  description = "Engine type for RDS database"
  type        = string
  default     = "aurora-mysql"
}

variable "rds_engine_version" {
  description = "Engine version number for RDS database"
  type        = string
  default     = "5.7.mysql_aurora.2.07.2"
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