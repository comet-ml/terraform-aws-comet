output "allinone_sg_id" {
  value       = aws_security_group.allinone_sg.id
  description = "ID of the security group associated with the allinone instance"
}