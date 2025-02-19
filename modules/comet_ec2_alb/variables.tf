variable "environment" {
  description = "Deployment environment, i.e. dev/stage/prod, etc"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC that will contain the provisioned resources"
  type        = string
}

variable "public_subnets" {
  description = "Subnets specified for ALB"
  type        = list(string)
}

variable "ssl_certificate_arn" {
  description = "ARN of the ACM certificate to use for the ALB"
  type        = string
}

variable "common_tags" {
  type        = map(string)
  description = "A map of common tags"
}
