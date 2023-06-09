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
  description = "Toggles the elasticache module for provisioning Comet Redis on elasticache"
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
variable "eks_private_subnets" {
  description = "IDs of private subnets within the VPC"
  type        = list(string)
  default     = null
}

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

variable "eks_mng_name" {
  description = "Name for the EKS managed nodegroup"
  type        = string
  default     = "mng"
}

variable "eks_mng_ami_type" {
  description = "AMI family to use for the EKS nodes"
  type        = string
  default     = "AL2_x86_64"
}

variable "eks_node_types" {
  description = "Node instance types for EKS managed node group"
  type        = list(string)
  default     = ["m5.4xlarge"]
}

variable "eks_mng_desired_size" {
  description = "Desired number of nodes in EKS cluster"
  type        = number
  default     = 3
}

variable "eks_mng_max_size" {
  description = "Maximum number of nodes in EKS cluster"
  type        = number
  default     = 6
}

variable "eks_aws_load_balancer_controller" {
  description = "Enables the AWS Load Balancer Controller in the EKS cluster"
  type        = bool
  default     = true
}

variable "eks_cert_manager" {
  description = "Enables cert-manager in the EKS cluster"
  type        = bool
  default     = true
}

variable "eks_aws_cloudwatch_metrics" {
  description = "Enables AWS Cloudwatch Metrics in the EKS cluster"
  type        = bool
  default     = true
}

variable "eks_external_dns" {
  description = "Enables ExternalDNS in the EKS cluster"
  type        = bool
  default     = true
}

#comet_elasticache
variable "elasticache_private_subnets" {
  description = "IDs of private subnets within the VPC"
  type        = list(string)
  default     = null
}

variable "elasticache_engine" {
  description = "Engine type for ElastiCache cluster"
  type        = string
  default     = "redis"
}

variable "elasticache_engine_version" {
  description = "Version number for ElastiCache engine"
  type        = string
  default     = "5.0.6"
}

variable "elasticache_instance_type" {
  description = "ElastiCache instance type"
  type        = string
  default     = "cache.r4.xlarge"
}

variable "elasticache_param_group_name" {
  description = "Name for the ElastiCache cluster parameter group"
  type        = string
  default     = "default.redis5.0"
}

variable "elasticache_num_cache_nodes" {
  description = "Number of nodes in the ElastiCache cluster"
  type        = number
  default     = 1
}

#comet_rds
variable "rds_root_password" {
  description = "Root password for RDS database"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name for S3 bucket"
  type        = string
  default     = ""
}