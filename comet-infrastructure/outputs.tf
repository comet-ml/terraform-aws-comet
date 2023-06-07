output "region" {
  description = "Region resources are provisioned in"
  value       = var.region
}

output "comet_ec2_instance" {
  description = "ID of the Comet EC2 instance"
  value       = var.enable_ec2 ? module.comet_ec2[0].comet_ec2_instance_id : null
}

output "comet_ec2_public_ip" {
  description = "EIP associated with the Comet EC2 instance"
  value       = var.enable_ec2 ? module.comet_ec2[0].comet_ec2_public_ip : null
}

output "comet_alb_dns_name" {
  description = "DNS name of the ALB fronting the Comet EC2 instance"
  value       = var.enable_ec2_alb ? module.comet_ec2_alb[0].alb_dns_name : null
}

output "mysql_host" {
  description = "Endpoint for the RDS instance"
  value       = var.enable_rds ? module.comet_rds[0].mysql_host : null
}

output "configure_kubectl" {
  description = "Configure kubectl: run the following command to update your kubeconfig with the newly provisioned cluster."
  value       = var.enable_eks ? "aws eks update-kubeconfig --region ${var.region} --name ${module.comet_eks[0].cluster_name}" : null
}