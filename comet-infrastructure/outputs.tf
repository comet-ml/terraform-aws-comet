output "configure_kubectl" {
  description = "Configure kubectl: run the following command to update your kubeconfig with the newly provisioned cluster."
  value       = var.enable_eks ? "aws eks update-kubeconfig --region ${var.region} --name ${module.comet_eks[0].cluster_name}" : null
}