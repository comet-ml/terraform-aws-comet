variable "environment" {
  description = "Deployment environment, i.e. dev/stage/prod, etc"
  type        = string
}

variable "alb_enabled" {
  description = "Indicates if ALB is being provisioned for Comet EC2 instance"
  type        = bool
  default     = null
}

variable "s3_enabled" {
  description = "Indicates if S3 bucket is being provisioned for Comet"
  type        = bool
  default     = null
}

variable "vpc_id" {
  description = "ID of the VPC that will contain the provisioned resources"
  type        = string
}

variable "comet_ec2_ami_type" {
  description = "Operating system type for the EC2 instance AMI"
  type        = string
}

variable "comet_ec2_instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "comet_ec2_ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "comet_ec2_instance_count" {
  description = "Number of EC2 instances to provision"
  type        = number
}

variable "comet_ec2_volume_type" {
  description = "EBS volume type for the EC2 instance root volume"
  type        = string
}

variable "comet_ec2_volume_size" {
  description = "Size, in gibibytes (GiB), for the EC2 instance root volume"
  type        = number
}

variable "comet_ec2_subnet" {
  description = "ID of VPC subnet to launch EC2 instance in"
  type        = string
}

variable "comet_ec2_key" {
  description = "Name of the SSH key to configure on the EC2 instance"
  type        = string
}

variable "comet_ec2_s3_iam_policy" {
  description = "Policy granting access to Comet S3 bucket"
  type        = string
}

variable "comet_ec2_alb_sg" {
  description = "ID of the security group attached to an associated application load balancer, for creating ingress EC2 SG rule"
  type        = string
}

variable "common_tags" {
  type        = map(string)
  description = "A map of common tags"
}
