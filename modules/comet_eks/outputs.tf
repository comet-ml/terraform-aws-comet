output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for the EKS cluster API server"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "nodegroup_sg_id" {
  description = "ID of the node shared security group"
  value       = module.eks.node_security_group_id
}

output "cluster_autoscaler_irsa_role_arn" {
  description = "ARN of the Cluster Autoscaler IRSA role (serviceAccountName=kube-system/cluster-autoscaler). Wire this into the cluster-autoscaler Helm values as the service account annotation."
  value       = var.eks_enable_cluster_autoscaler ? module.cluster_autoscaler_irsa_role[0].iam_role_arn : null
}

output "cluster_autoscaler_irsa_role_name" {
  description = "Name of the Cluster Autoscaler IRSA role"
  value       = var.eks_enable_cluster_autoscaler ? module.cluster_autoscaler_irsa_role[0].iam_role_name : null
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC provider for the EKS cluster"
  value       = module.eks.oidc_provider_arn
}