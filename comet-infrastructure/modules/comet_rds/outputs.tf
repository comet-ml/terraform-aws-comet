output "mysql_host" {
  description = "MySQL endpoint"
  value       = aws_rds_cluster.cometml-db-cluster.endpoint
}