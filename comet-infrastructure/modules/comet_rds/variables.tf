variable "environment" {
  description = "Deployment environment, i.e. dev/stage/prod, etc"
  type        = string
  default     = "dev"
}

variable "availability_zones" {
  description = "List of availability zones from VPC"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the VPC that will contain the provisioned resources"
  type        = string
}

variable "rds_private_subnets" {
  description = "IDs of private subnets within the VPC"
  type        = list(string)
}

variable "rds_allow_ec2_sg" {
  description = "Security group associated with EC2 compute, if provisioned"
  type        = string
}

variable "rds_allow_eks_sg" {
  description = "Security group associated with EKS compute, if provisioned"
  type        = string
}

variable "rds_engine" {
  description = "Engine type for RDS database"
  type        = string
}

variable "rds_engine_version" {
  description = "Engine version number for RDS database"
  type        = string
}

variable "rds_instance_type" {
  description = "Instance type for RDS database"
  type        = string
}

variable "rds_instance_count" {
  description = "Number of RDS instances in the database cluster"
  type        = number
}

variable "rds_storage_encrypted" {
  description = "Enables encryption for RDS storage"
  type        = bool
}

variable "rds_iam_db_auth" {
  description = "Enables IAM auth for the database in RDS"
  type        = bool
}

variable "rds_backup_retention_period" {
  description = "Days specified for RDS snapshotretention period"
  type        = number
}

variable "rds_preferred_backup_window" {
  description = "Backup window for RDS"
  type        = string
}

variable "rds_database_name" {
  description = "Name for the application database in RDS"
  type        = string
}

variable "rds_root_password" {
  description = "Root password for RDS database"
  type        = string
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