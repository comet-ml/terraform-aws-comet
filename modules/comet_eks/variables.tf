variable "environment" {
  description = "Deployment environment, i.e. dev/stage/prod, etc"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC that the EKS cluster will be launched in"
  type        = string
}

variable "eks_private_subnets" {
  description = "IDs of private subnets within the VPC"
  type        = list(string)
}

variable "eks_cluster_name" {
  description = "Name for the EKS cluster"
  type        = string
}

variable "eks_cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

variable "eks_cluster_endpoint_public_access" {
  description = "Enable public access to the EKS cluster API endpoint"
  type        = bool
  default     = true
}

variable "eks_cluster_endpoint_private_access" {
  description = "Enable private access to the EKS cluster API endpoint"
  type        = bool
  default     = false
}

variable "eks_cluster_security_group_additional_rules" {
  description = "Additional security group rules for the EKS cluster security group"
  type        = any
  default     = {}
}

variable "eks_private_access_cidrs" {
  description = "List of CIDR blocks that can access the EKS API via private endpoint (e.g., VPN subnets). Only applied when private endpoint access is enabled."
  type        = list(string)
  default     = []
}

variable "eks_authentication_mode" {
  description = "Authentication mode for the EKS cluster. Valid values: CONFIG_MAP, API, API_AND_CONFIG_MAP"
  type        = string
  default     = "API_AND_CONFIG_MAP"
}

variable "eks_enable_cluster_creator_admin_permissions" {
  description = "Grant the cluster creator admin permissions via EKS access entry"
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

variable "eks_mng_ami_type" {
  description = "AMI family to use for the EKS nodes"
  type        = string
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
}

variable "eks_aws_load_balancer_controller" {
  description = "Enables the AWS Load Balancer Controller in the EKS cluster"
  type        = bool
}

variable "eks_cert_manager" {
  description = "Enables cert-manager in the EKS cluster"
  type        = bool
}

variable "eks_aws_cloudwatch_metrics" {
  description = "Enables AWS Cloudwatch Metrics in the EKS cluster"
  type        = bool
}

variable "eks_external_dns" {
  description = "Enables ExternalDNS in the EKS cluster"
  type        = bool
}

variable "eks_external_dns_r53_zones" {
  description = "Route 53 zones for external-dns to have access to"
  type        = list(string)
}

variable "s3_enabled" {
  description = "Indicates if S3 bucket is being provisioned for Comet"
  type        = bool
  default     = null
}

variable "comet_ec2_s3_iam_policy" {
  description = "Policy with access to S3 to associate with EKS worker nodes"
  type        = string
  default     = null
}

# Node Group Toggles
variable "enable_admin_node_group" {
  description = "Enable admin node group for EKS cluster management tasks"
  type        = bool
  default     = true
}

variable "enable_comet_node_group" {
  description = "Enable comet node group for main Comet application workloads"
  type        = bool
  default     = true
}

variable "enable_druid_node_group" {
  description = "Enable druid node group for Apache Druid workloads (requires enable_mpm_infra to be true)"
  type        = bool
  default     = true
}

variable "enable_airflow_node_group" {
  description = "Enable airflow node group for Apache Airflow workloads (requires enable_mpm_infra to be true)"
  type        = bool
  default     = true
}

variable "enable_mpm_infra" {
  description = "Master toggle for MPM infrastructure (Druid/Airflow node groups will only be created if this is true)"
  type        = bool
  default     = false
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

variable "common_tags" {
  type        = map(string)
  description = "A map of common tags"
  default     = {}
}

# ClickHouse Node Group Toggle
variable "enable_clickhouse_node_group" {
  description = "Enable dedicated ClickHouse node group"
  type        = bool
  default     = false
}

# ClickHouse Node Group Variables
variable "eks_clickhouse_name" {
  description = "Name for the ClickHouse node group"
  type        = string
  default     = "clickhouse"
}

variable "eks_clickhouse_instance_types" {
  description = "Instance types for the ClickHouse node group"
  type        = list(string)
  default     = ["m7i.2xlarge"]
}

variable "eks_clickhouse_min_size" {
  description = "Minimum number of ClickHouse nodes"
  type        = number
  default     = 2
}

variable "eks_clickhouse_max_size" {
  description = "Maximum number of ClickHouse nodes"
  type        = number
  default     = 3
}

variable "eks_clickhouse_desired_size" {
  description = "Desired number of ClickHouse nodes"
  type        = number
  default     = 2
}

variable "eks_clickhouse_volume_size" {
  description = "EBS volume size in GB for ClickHouse nodes"
  type        = number
  default     = 500
}

variable "eks_clickhouse_volume_type" {
  description = "EBS volume type for ClickHouse nodes"
  type        = string
  default     = "gp3"
}

variable "eks_clickhouse_volume_encrypted" {
  description = "Enable EBS encryption for ClickHouse volumes"
  type        = bool
  default     = true
}

variable "eks_clickhouse_delete_on_termination" {
  description = "Delete EBS volumes on instance termination"
  type        = bool
  default     = true
}

variable "additional_node_groups" {
  description = "Additional EKS managed node groups to create beyond the predefined ones (admin, comet, druid, airflow, clickhouse)"
  type        = any
  default     = {}
}

variable "additional_s3_bucket_arns" {
  description = "Additional S3 bucket ARNs to grant access to (for buckets created outside this module)"
  type        = list(string)
  default     = []
}
