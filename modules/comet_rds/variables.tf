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

variable "rds_enhanced_monitoring_interval" {
  description = "Interval in seconds for Enhanced Monitoring metrics collection. Valid values are 0, 1, 5, 10, 15, 30, 60. Set to 0 to disable Enhanced Monitoring."
  type        = number
  default     = 60
}

variable "rds_performance_insights_enabled" {
  description = "Enable Performance Insights for RDS instances"
  type        = bool
  default     = true
}

variable "rds_performance_insights_retention_period" {
  description = "Retention period for Performance Insights data in days. Valid values are 7, 31, 62, 93, 124, 155, 186, 217, 248, 279, 310, 341, 372, 403, 434, 465, 496, 527, 558, 589, 620, 651, 682, 713, or 731."
  type        = number
  default     = 7
}

variable "rds_storage_type" {
  description = "Aurora storage type. Use 'aurora-iopt1' for I/O-Optimized (eliminates I/O charges, 30% instance surcharge). Default null uses Aurora Standard."
  type        = string
  default     = null
}

variable "rds_cluster_parameters" {
  description = "Additional MySQL parameters applied to the cluster parameter group on top of the module's baseline character-set/collation/innodb defaults. Defaults include operational tunings (wait_timeout, max_execution_time, innodb purge settings, aurora_read_replica_read_committed) used across Comet STSAAS deployments. Pass [] to disable, or override with a custom list."
  type = list(object({
    name         = string
    value        = string
    apply_method = string
  }))
  default = [
    { name = "aurora_read_replica_read_committed", value = "ON", apply_method = "immediate" },
    { name = "innodb_max_purge_lag", value = "1000000", apply_method = "immediate" },
    { name = "innodb_max_purge_lag_delay", value = "300000", apply_method = "immediate" },
    { name = "innodb_purge_batch_size", value = "5000", apply_method = "immediate" },
    { name = "innodb_purge_threads", value = "16", apply_method = "pending-reboot" },
    { name = "max_execution_time", value = "60000", apply_method = "immediate" },
    { name = "wait_timeout", value = "1800", apply_method = "immediate" },
  ]
}
