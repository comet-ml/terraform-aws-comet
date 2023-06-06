variable "environment" {
  description = "Deployment environment, i.e. dev/stage/prod, etc"
  type        = string
  default     = "dev"
}

variable "vpc_id" {
  description = "ID of the VPC that will contain the provisioned resources"
  type        = string
  #default     = ""
}

variable "public_subnets" {
  description = "Subnets specified for ALB"
  type        = list
}

variable "ssl_certificate_arn" {
  description = "ARN of the ACM certificate to use for the ALB"
  type        = string
}