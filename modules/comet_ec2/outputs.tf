output "comet_ec2_sg_id" {
  description = "ID of the security group associated with the EC2 instance"
  value       = aws_security_group.comet_ec2_sg.id
}

output "comet_ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.comet_ec2[0].id
}

output "comet_ec2_public_ip" {
  description = "Public IP of the EIP associated with the EC2 instance"
  value       = var.alb_enabled ? null : aws_eip.comet_ec2_eip[0].public_ip
}