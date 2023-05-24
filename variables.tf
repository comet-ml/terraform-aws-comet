variable "enable_ec2_deployment" {
  description = "Toggles the ec2_deployment module, to provision EC2 resources for running Comet"
  type        = bool
}

variable "enable_eks_deployment" {
  description = "Toggles the ec2_deployment module, to provision EKS resources for running Comet"
  type        = bool
}

variable "enable_external_dependencies" {
  description = "Toggles the external_dependencies module, for provisioning ElasticCache Redis/RDS/S3"
  type        = bool
}