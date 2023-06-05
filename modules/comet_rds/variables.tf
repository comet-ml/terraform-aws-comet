variable "environment" {
  description = "Deployment environment, i.e. dev/stage/prod, etc"
  type        = string
  default     = "dev"
}

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

variable "availability_zones" {
  description = "List of availability zones from VPC"
  type        = list(string)
  default     = []
}

variable "elasticache_rds_allowfrom_sg" {
  description = "Security group(s) attached to the Comet instance(s); Specified in the ingress allow rules on the Elasticache and RDS security groups"
  type        = string
  default     = ""
}