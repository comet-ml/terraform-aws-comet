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

variable "eks_mng_name" {
  description = "Name for the EKS managed nodegroup"
  type        = string
}

variable "eks_mng_ami_type" {
  description = "AMI family to use for the EKS nodes"
  type        = string
}

variable "eks_node_types" {
  description = "Node instance types for EKS managed node group"
  type        = list(string)
}

variable "eks_mng_desired_size" {
  description = "Desired number of nodes in EKS cluster"
  type        = number
}

variable "eks_mng_max_size" {
  description = "Maximum number of nodes in EKS cluster"
  type        = number
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

variable "enable_mpm_infra" {
  description = "Sets MNGs to be created for MPM compute"
  type        = bool
}

variable "eks_druid_instance_type" {
  description = "Instance type for EKS Druid nodes"
  type        = string
}

variable "eks_druid_node_count" {
  description = "Instance count for EKS Druid nodes"
  type        = number
}

variable "eks_airflow_instance_type" {
  description = "Instance type for EKS Airflow nodes"
  type        = string
}

variable "eks_airflow_node_count" {
  description = "Instance count for EKS Airflow nodes"
  type        = number
}
