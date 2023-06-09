#global
variable "environment" {
  description = "Deployment environment, i.e. dev/stage/prod, etc"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region to provision resources in"
  type        = string
}

#child module toggles
variable "enable_ec2" {
  description = "Toggles the EC2 module, to provision EC2 resources for running Comet"
  type        = bool
}

variable "enable_ec2_alb" {
  description = "Toggles the ALB module, to provision an ALB in front of the EC2 instance"
  type        = bool
}

variable "enable_eks" {
  description = "Toggles the EKS module, to provision EKS resources for running Comet"
  type        = bool
}

variable "enable_elasticache" {
  description = "Toggles the ElastiCache module for provisioning Comet Redis on ElastiCache"
  type        = bool
}

variable "enable_rds" {
  description = "Toggles the RDS module for provisioning Comet RDS database"
  type        = bool
}

variable "enable_s3" {
  description = "Toggles the S3 module for provisioning Comet S3 bucket"
  type        = bool
}

#comet_ec2
variable "comet_ec2_subnet" {
  description = "ID of VPC subnet to launch EC2 instance in"
  type        = string
  default     = null
}

variable "comet_ec2_ami" {
  description = "AMI for Comet EC2 instance"
  type        = string
  default     = "ami-05842f1afbf311a43"
}

variable "comet_ec2_instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "m5.4xlarge"
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

variable "comet_ec2_key" {
  description = "Name of the SSH key to configure on the EC2 instance"
  type        = string
  default     = null
}

#comet_ec2_alb
variable "ssl_certificate_arn" {
  description = "ARN of the ACM certificate to use for the ALB"
  type        = string
  default     = ""
}

#comet_eks
variable "eks_cluster_name" {
  description = "Name for EKS cluster"
  type        = string
  default     = "comet-eks"
}

variable "eks_cluster_version" {
  description = "Kubernetes version of the EKS cluster"
  type        = string
  default     = "1.26"
}

# comet_rds
variable "rds_root_password" {
  description = "Root password for RDS database"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name for S3 bucket"
  type        = string
  default     = ""
}