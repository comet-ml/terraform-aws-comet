variable "environment" {
  description = "Deployment environment, i.e. dev/stage/prod, etc"
  type        = string
  default     = "dev"
}

variable "comet_ml_s3_bucket" {
  description = "Name of S3 bucket"
  type        = string
}