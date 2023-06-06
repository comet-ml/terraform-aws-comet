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

variable "comet_ec2_ami" {
  description = "AMI for the EC2 instance"
  type        = string
  default     = ""
}

variable "comet_ec2_instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "m5.4xlarge"
}

variable "key_name" {
  description = "Name of the SSH key to configure on the EC2 instance"
  type        = string
  default     = ""
}

variable "comet_ec2_instance_count" {
  description = "Number of EC2 instances to provision"
  type        = number
  default     = 1
}

variable "comet_ec2_volume_type" {
  description = "EBS volume type for the EC2 instance root volume"
  type        = string
  default     = "gp2"
}

variable "comet_ec2_volume_size" {
  description = "Size, in gibibytes (GiB), for the EC2 instance root volume"
  type        = number
  default     = 1024
}

variable "comet_ec2_subnet" {
  description = "ID of VPC subnet to launch EC2 instance in"
  type        = string
  default     = ""
}

variable "s3_enabled" {
  description = "Indicates if S3 bucket is being provisioned for Comet"
  type        = bool
  default     = null
}

variable "comet_ml_s3_bucket" {
  description = "Name of the S3 bucket provisioned for Comet"
  type        = string
  default     = null
}

variable "comet_ec2_s3_iam_policy" {
  description = "Policy granting access to Comet S3 bucket"
  type        = string
}