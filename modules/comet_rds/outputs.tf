output "mysql_host" {
  description = "MySQL endpoint"
  value       = aws_rds_cluster.cometml-db-cluster.endpoint
}

output "mysql_port" {
  description = "MySQL port"
  value       = aws_rds_cluster.cometml-db-cluster.port
}

output "mysql_root_username" {
  description = "MySQL root username"
  value       = aws_rds_cluster.cometml-db-cluster.master_username
}

output "mysql_database" {
  description = "MySQL database name"
  value       = aws_rds_cluster.cometml-db-cluster.database_name
}

output "mysql_username" {
  description = "MySQL username (same as root username)"
  value       = aws_rds_cluster.cometml-db-cluster.master_username
}

output "mysql_enable_internal" {
  description = "Whether internal MySQL is enabled"
  value       = false
}

# output "mysql_root_password" {
#   description = "MySQL root password"
#   value       = var.rds_root_password
# }
# output "mysql_password" {
#   description = "MySQL password (same as root password)"
#   value       = var.rds_root_password
# }