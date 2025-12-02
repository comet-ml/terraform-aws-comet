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
  description = "Creates S3 buckets for MPM Druid/Airflow workloads (used by comet_s3 module)"
  type        = bool
  default     = false
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

#### comet_vpc ####
variable "vpc_cidr" {
  description = "CIDR block for the VPC to provision"
  type        = string
  default     = "10.0.0.0/16"
}

#### comet_ec2 ####
variable "comet_ec2_ami_type" {
  type        = string
  description = "Operating system type for the EC2 instance AMI"
  default     = "ubuntu22"
  validation {
    condition     = can(regex("^al2$|^al2023$|^rhel(7|8|9)$|^ubuntu(18|20|22)$", var.comet_ec2_ami_type))
    error_message = "Invalid OS type. Allowed values are 'al2', 'al2023', 'rhel7', 'rhel8', 'rhel9', 'ubuntu20', 'ubuntu22'."
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
  default     = "m7i.4xlarge"
}

variable "comet_ec2_instance_count" {
  description = "Number of EC2 instances to provision"
  type        = number
  default     = 1
}

variable "comet_ec2_volume_type" {
  description = "EBS volume type for the EC2 instance root volume"
  type        = string
  default     = "gp3"
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
  default     = "1.32"
}

variable "eks_mng_ami_type" {
  description = "AMI family to use for the EKS nodes"
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

# Node Group Toggles
variable "eks_enable_admin_node_group" {
  description = "Enable admin node group for EKS cluster management tasks"
  type        = bool
  default     = true
}

variable "eks_enable_comet_node_group" {
  description = "Enable comet node group for main Comet application workloads"
  type        = bool
  default     = true
}

variable "eks_enable_druid_node_group" {
  description = "Enable druid node group for Apache Druid workloads (requires enable_mpm_infra to be true)"
  type        = bool
  default     = true
}

variable "eks_enable_airflow_node_group" {
  description = "Enable airflow node group for Apache Airflow workloads (requires enable_mpm_infra to be true)"
  type        = bool
  default     = true
}

# Admin Node Group Variables
variable "eks_admin_name" {
  description = "Name for the admin node group"
  type        = string
  default     = "admin"
}

variable "eks_admin_instance_types" {
  description = "Instance types for admin node group"
  type        = list(string)
  default     = ["t3.large"]
}

variable "eks_admin_min_size" {
  description = "Minimum number of nodes in admin node group"
  type        = number
  default     = 1
}

variable "eks_admin_max_size" {
  description = "Maximum number of nodes in admin node group"
  type        = number
  default     = 3
}

variable "eks_admin_desired_size" {
  description = "Desired number of nodes in admin node group"
  type        = number
  default     = 2
}

# Comet Node Group Variables
variable "eks_comet_name" {
  description = "Name for the comet node group"
  type        = string
  default     = "comet"
}

variable "eks_comet_instance_types" {
  description = "Instance types for comet node group"
  type        = list(string)
  default     = ["m7i.4xlarge"]
}

variable "eks_comet_min_size" {
  description = "Minimum number of nodes in comet node group"
  type        = number
  default     = 2
}

variable "eks_comet_max_size" {
  description = "Maximum number of nodes in comet node group"
  type        = number
  default     = 10
}

variable "eks_comet_desired_size" {
  description = "Desired number of nodes in comet node group"
  type        = number
  default     = 3
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
  default     = false
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

# Druid Node Group Variables
variable "eks_druid_name" {
  description = "Name for the druid node group"
  type        = string
  default     = "druid"
}

variable "eks_druid_instance_types" {
  description = "Instance types for druid node group"
  type        = list(string)
  default     = ["m7i.2xlarge"]
}

variable "eks_druid_min_size" {
  description = "Minimum number of nodes in druid node group"
  type        = number
  default     = 2
}

variable "eks_druid_max_size" {
  description = "Maximum number of nodes in druid node group"
  type        = number
  default     = 8
}

variable "eks_druid_desired_size" {
  description = "Desired number of nodes in druid node group"
  type        = number
  default     = 4
}

# Airflow Node Group Variables
variable "eks_airflow_name" {
  description = "Name for the airflow node group"
  type        = string
  default     = "airflow"
}

variable "eks_airflow_instance_types" {
  description = "Instance types for airflow node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "eks_airflow_min_size" {
  description = "Minimum number of nodes in airflow node group"
  type        = number
  default     = 1
}

variable "eks_airflow_max_size" {
  description = "Maximum number of nodes in airflow node group"
  type        = number
  default     = 4
}

variable "eks_airflow_desired_size" {
  description = "Desired number of nodes in airflow node group"
  type        = number
  default     = 2
}

variable "eks_additional_node_groups" {
  description = "Additional EKS managed node groups to create beyond the predefined ones (admin, comet, druid, airflow)"
  type        = any
  default     = {}
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
  default     = "7.1"
}

variable "elasticache_instance_type" {
  description = "ElastiCache instance type"
  type        = string
  default     = "cache.r4.xlarge"
}

variable "elasticache_param_group_name" {
  description = "Name for the ElastiCache cluster parameter group"
  type        = string
  default     = "default.redis7"
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

variable "rds_master_username" {
  description = "Master username for RDS database"
  type        = string
	default     = "admin"
}

variable "rds_master_password" {
  description = "Master password for RDS database"
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

variable "common_tags" {
  description = "A map of tags to apply to resources"
  type        = map(string)
}

variable "environment_tag" {
  description = "Deployment identifier"
  type = string
  default = ""
}
