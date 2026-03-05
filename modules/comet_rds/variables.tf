variable "environment" {
  description = "Deployment environment, i.e. dev/stage/prod, etc"
  type        = string
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

variable "rds_allow_from_sg" {
  description = "Security group from which to allow connections to RDS"
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

variable "rds_master_username" {
  description = "Master username for RDS database"
  type        = string
	default     = "admin"
}

variable "rds_master_password" {
  description = "Master password for RDS database"
  type        = string
}

variable "common_tags" {
  type        = map(string)
  description = "A map of common tags"
  default     = {}
}

variable "rds_snapshot_identifier" {
  description = "Snapshot identifier to restore the RDS cluster from. If provided, the cluster will be restored from this snapshot instead of being created fresh."
  type        = string
  default     = null
}

variable "rds_kms_key_id" {
  description = "ARN of the KMS key to use for encryption. Required when restoring from a KMS-encrypted shared snapshot. If not specified, the default RDS KMS key will be used."
  type        = string
  default     = null
}

variable "rds_monitoring_interval" {
  description = "Enhanced Monitoring interval in seconds. Valid values: 0, 1, 5, 10, 15, 30, 60. Set to 0 to disable."
  type        = number
  default     = 0
}

variable "rds_performance_insights_enabled" {
  description = "Enable Performance Insights for RDS instances"
  type        = bool
  default     = false
}

variable "rds_performance_insights_retention_period" {
  description = "Performance Insights retention period in days. Valid values: 7, 731, or multiples of 31."
  type        = number
  default     = 7
}
