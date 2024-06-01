########################
#### Module toggles ####
########################
variable "enable_vpc" {
  description = "Toggles the comet_vpc module, to provision a new VPC for hosting the Comet resources"
  type        = bool
}

variable "enable_ec2" {
  description = "Toggles the comet_ec2 module, to provision EC2 resources for running Comet"
  type        = bool
}

variable "enable_ec2_alb" {
  description = "Toggles the comet_ec2_alb module, to provision an ALB in front of the EC2 instance"
  type        = bool
}

variable "enable_eks" {
  description = "Toggles the comet_eks module, to provision EKS resources for running Comet"
  type        = bool
}

variable "enable_elasticache" {
  description = "Toggles the comet_elasticache module for provisioning Comet Redis on elasticache"
  type        = bool
}

variable "enable_rds" {
  description = "Toggles the comet_rds module for provisioning Comet RDS database"
  type        = bool
}

variable "enable_s3" {
  description = "Toggles the comet_s3 module for provisioning Comet S3 bucket"
  type        = bool
}

variable "enable_mpm_infra" {
  description = "Sets MNGs to be created for MPM compute"
  type        = bool
}

################
#### Global ####
################
variable "environment" {
  description = "Deployment environment, i.e. dev/stage/prod, etc"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region to provision resources in"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones from region"
  type        = list(string)
  default     = null
}

variable "comet_vpc_id" {
  description = "ID of an existing VPC to provision resources in"
  type        = string
  default     = null
}

variable "comet_private_subnets" {
  description = "List of private subnets IDs from existing VPC to provision resources in"
  type        = list(string)
  default     = null
}

variable "comet_public_subnets" {
  description = "List of public subnets IDs from existing VPC to provision resources in"
  type        = list(string)
  default     = null
}

#######################
#### Module inputs ####
#######################

#### comet_ec2 ####
variable "comet_ec2_ami_type" {
  type        = string
  description = "Operating system type for the EC2 instance AMI"
  default     = "ubuntu22"
  validation {
    condition     = can(regex("^al2$|^rhel(7|8|9)$|^ubuntu(18|20|22)$", var.comet_ec2_ami_type))
    error_message = "Invalid OS type. Allowed values are 'al2', 'rhel7', 'rhel8', 'rhel9', 'ubuntu18', 'ubuntu20', 'ubuntu22'."
  }
}

variable "comet_ec2_ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = ""
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

#### comet_ec2_alb ####
variable "ssl_certificate_arn" {
  description = "ARN of the ACM certificate to use for the ALB"
  type        = string
  default     = null
}

#### comet_eks ####
variable "eks_cluster_name" {
  description = "Name for EKS cluster"
  type        = string
  default     = "comet-eks"
}

variable "eks_cluster_version" {
  description = "Kubernetes version of the EKS cluster"
  type        = string
  default     = "1.27"
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
  default     = ["m6i.4xlarge"]
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

variable "eks_mng_disk_size" {
  description = "Size of the storage disks for nodes in EKS cluster"
  type        = number
  default     = 500
}

variable "eks_aws_load_balancer_controller" {
  description = "Enables the AWS Load Balancer Controller in the EKS cluster"
  type        = bool
  default     = true
}

variable "eks_cert_manager" {
  description = "Enables cert-manager in the EKS cluster"
  type        = bool
  default     = false
}

variable "eks_aws_cloudwatch_metrics" {
  description = "Enables AWS Cloudwatch Metrics in the EKS cluster"
  type        = bool
  default     = true
}

variable "eks_external_dns" {
  description = "Enables ExternalDNS in the EKS cluster"
  type        = bool
  default     = false
}

variable "eks_external_dns_r53_zones" {
  description = "Route 53 zones for external-dns to have access to"
  type        = list(string)
  default = [
    "arn:aws:route53:::hostedzone/XYZ"
  ]
}

variable "eks_druid_instance_type" {
  description = "Instance type for EKS Druid nodes"
  type        = string
  default     = "m7i.2xlarge"
}

variable "eks_druid_node_count" {
  description = "Instance count for EKS Druid nodes"
  type        = number
  default     = 4
}

variable "eks_airflow_instance_type" {
  description = "Instance type for EKS Airflow nodes"
  type        = string
  default     = "t3.medium"
}

variable "eks_airflow_node_count" {
  description = "Instance count for EKS Airflow nodes"
  type        = number
  default     = 2
}

#### comet_elasticache ####
variable "elasticache_allow_from_sg" {
  description = "Security group from which to allow connections to ElastiCache, to use when provisioning with existing compute"
  type        = string
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

variable "elasticache_transit_encryption" {
  description = "Enable transit encryption for ElastiCache"
  type        = bool
  default     = false
}

variable "elasticache_auth_token" {
  description = "Auth token for ElastiCache"
  type        = string
  default     = null
}

#### comet_rds ####
variable "rds_allow_from_sg" {
  description = "Security group from which to allow connections to RDS, to use when provisioning with existing compute"
  type        = string
  default     = null
}

variable "rds_engine" {
  description = "Engine type for RDS database"
  type        = string
  default     = "aurora-mysql"
}

variable "rds_engine_version" {
  description = "Engine version number for RDS database"
  type        = string
  default     = "8.0"
}

variable "rds_instance_type" {
  description = "Instance type for RDS database"
  type        = string
  default     = "db.r5.xlarge"
}

variable "rds_instance_count" {
  description = "Number of RDS instances in the database cluster"
  type        = number
  default     = 2
}

variable "rds_storage_encrypted" {
  description = "Enables encryption for RDS storage"
  type        = bool
  default     = true
}

variable "rds_iam_db_auth" {
  description = "Enables IAM auth for the database in RDS"
  type        = bool
  default     = true
}

variable "rds_backup_retention_period" {
  description = "Days specified for RDS snapshotretention period"
  type        = number
  default     = 7
}

variable "rds_preferred_backup_window" {
  description = "Backup window for RDS"
  type        = string
  default     = "07:00-09:00"
}

variable "rds_database_name" {
  description = "Name for the application database in RDS"
  type        = string
  default     = "logger"
}

variable "rds_root_password" {
  description = "Root password for RDS database"
  type        = string
}

#### comet_s3 ####
variable "s3_bucket_name" {
  description = "Name for S3 bucket"
  type        = string
}

variable "s3_force_destroy" {
  description = "Option to enable force delete of S3 bucket"
  type        = bool
  default     = false
}

#### comet_vpc ####
variable "single_nat_gateway" {
  description = "Controls whether single NAT gateway used for all public subnets"
  type        = bool
  default     = true
}