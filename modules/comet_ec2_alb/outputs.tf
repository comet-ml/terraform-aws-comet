output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.alb.lb_dns_name
}

output "comet_alb_sg" {
  description = "ID of the security group created for the ALB"
  value       = aws_security_group.comet_alb_sg.id
}