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