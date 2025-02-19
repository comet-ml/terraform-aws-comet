variable "environment" {
  description = "Deployment environment, i.e. dev/stage/prod, etc"
  type        = string
}

variable "comet_s3_bucket" {
  description = "Name of S3 bucket"
  type        = string
}

variable "s3_force_destroy" {
  description = "Option to enable force delete of S3 bucket"
  type        = bool
}

variable "enable_mpm_infra" {
  description = "Sets buckets to be created for MPM Druid/Airflow"
  type        = bool
}

variable "common_tags" {
  type        = map(string)
  description = "A map of common tags"
}
