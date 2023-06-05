locals {
  mysql_port = 3306

  tags = {
    Terraform_Managed = "true"
    Environment       = var.environment
  }
}

resource "aws_security_group" "aurora_inbound_sg" {
  name        = "${var.environment}_aurora_inbound_sg"
  description = "Aurora Mysql RDS Security Group"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "aurora_port_inbound_allow" {
  security_group_id = aws_security_group.aurora_inbound_sg.id

  from_port   = local.mysql_port
  to_port     = local.mysql_port
  ip_protocol    = "tcp"
  # security groups need to change depending on whether Cx is using eks or ec2 deployment; hard-coded index won't work
  referenced_security_group_id = var.elasticache_rds_allowfrom_sg
}

resource "aws_db_subnet_group" "comet-ml-rds-subnet" {
  name = "cometml_rds_sgn_${var.environment}"
  subnet_ids = var.vpc_private_subnets
  tags = merge(local.tags, {
    Name = "cometml-rds_sng-${var.environment}"
  })
}

resource "aws_rds_cluster_instance" "comet-ml-rds-mysql" {
  count              = var.rds_instance_count
  identifier         = "cometml-mysql-${var.environment}-${count.index}"
  cluster_identifier = aws_rds_cluster.comet-ml-cluster.id
  instance_class     = var.rds_instance_type
  engine             = var.rds_engine
  engine_version     = var.rds_engine_version
}


resource "aws_rds_cluster" "comet-ml-cluster" {
  cluster_identifier   = "cometml-mysql-cluster-${var.environment}"
  db_subnet_group_name = aws_db_subnet_group.comet-ml-rds-subnet.name
  availability_zones                  = var.availability_zones
  database_name                       = "logger"
  storage_encrypted                   = true
  iam_database_authentication_enabled = true
  master_username                     = "root"
  master_password                     = var.rds_root_password
  engine                              = var.rds_engine
  engine_version                      = var.rds_engine_version
  backup_retention_period             = 7
  final_snapshot_identifier           = "comet-ml-rds-backup-${var.environment}"
  preferred_backup_window             = "07:00-09:00"
  vpc_security_group_ids              = [aws_security_group.aurora_inbound_sg.id]
  db_cluster_parameter_group_name     = aws_rds_cluster_parameter_group.comet-ml-cluster-pg.name
}

resource "aws_rds_cluster_parameter_group" "comet-ml-cluster-pg" {
  name        = "cometml-rds-cluster-pg-${var.environment}"
  family      = "aurora-mysql5.7"
  description = "Comet ML RDS cluster parameter group"

  parameter {
    apply_method = "pending-reboot"
    name  = "character_set_server"
    value = "utf8mb4"
  }
  parameter {
    apply_method = "pending-reboot"
    name  = "character_set_connection"
    value = "utf8mb4"
  }
  parameter {
    apply_method = "pending-reboot"
    name  = "character_set_database"
    value = "utf8mb4"
  }
  parameter {
    apply_method = "pending-reboot"
    name  = "character_set_results"
    value = "utf8mb4"
  }
  parameter {
    apply_method = "pending-reboot"
    name  = "collation_connection"
    value = "utf8mb4_unicode_ci"
  }
  parameter {
    apply_method = "pending-reboot"
    name  = "collation_server"
    value = "utf8mb4_unicode_ci"
  }
  parameter {
    apply_method = "pending-reboot"
    name  = "innodb_flush_log_at_trx_commit"
    value = "1"
  }
  parameter {
    apply_method = "pending-reboot"
    name  = "innodb_lock_wait_timeout"
    value = "120"
  }
  parameter {
    apply_method = "pending-reboot"
    name  = "max_allowed_packet"
    value = "157286400"
  }
  parameter {
    apply_method = "pending-reboot"
    name  = "thread_stack"
    value = "2000000"
  }
}