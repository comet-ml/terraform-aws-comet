output "comet_ec2_sg_id" {
  value       = aws_security_group.comet_ec2_sg.id
  description = "ID of the security group associated with the comet_ec2 instance"
}