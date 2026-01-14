locals {
  mysql_port = 3306
}

resource "aws_db_subnet_group" "comet-ml-rds-subnet" {
  name       = "cometml-rds-sgn-${var.environment}"
  subnet_ids = var.rds_private_subnets
  tags = merge(
    var.common_tags,
    {
      Name = "cometml-rds-sng-${var.environment}"
    }
  )
}

resource "aws_rds_cluster_instance" "comet-ml-rds-mysql" {
  count              = var.rds_instance_count
  identifier         = "cometml-rds-${var.environment}-${count.index}"
  cluster_identifier = aws_rds_cluster.cometml-db-cluster.id
  instance_class     = var.rds_instance_type
  engine             = var.rds_engine
  engine_version     = var.rds_engine_version
}

resource "aws_rds_cluster" "cometml-db-cluster" {
  cluster_identifier                  = "cometml-rds-cluster-${var.environment}"
  db_subnet_group_name                = aws_db_subnet_group.comet-ml-rds-subnet.name
  availability_zones                  = var.availability_zones
  database_name                       = var.rds_snapshot_identifier == null ? var.rds_database_name : null
  storage_encrypted                   = var.rds_storage_encrypted
  kms_key_id                          = var.rds_kms_key_id
  iam_database_authentication_enabled = var.rds_iam_db_auth
  master_username                     = var.rds_snapshot_identifier == null ? var.rds_master_username : null
  master_password                     = var.rds_snapshot_identifier == null ? var.rds_master_password : null
  snapshot_identifier                 = var.rds_snapshot_identifier
  engine                              = var.rds_engine
  engine_version                      = var.rds_engine_version
  backup_retention_period             = var.rds_backup_retention_period
  final_snapshot_identifier           = "cometml-rds-backup-${var.environment}-${formatdate("DD-MMM-YYYY-hh-mm-ss", timestamp())}"
  preferred_backup_window             = var.rds_preferred_backup_window
  vpc_security_group_ids              = [aws_security_group.mysql_sg.id]
  db_cluster_parameter_group_name     = aws_rds_cluster_parameter_group.cometml-cluster-pg.name
  db_instance_parameter_group_name    = aws_rds_cluster_parameter_group.cometml-cluster-pg.name
  allow_major_version_upgrade         = true
}

resource "aws_rds_cluster_parameter_group" "cometml-cluster-pg" {
  name        = "cometml-rds-cluster-pg-${var.environment}"
  family      = "aurora-mysql${var.rds_engine_version}"
  description = "CometML RDS cluster parameter group"

  parameter {
    apply_method = "pending-reboot"
    name         = "character_set_server"
    value        = "utf8mb4"
  }
  parameter {
    apply_method = "pending-reboot"
    name         = "character_set_connection"
    value        = "utf8mb4"
  }
  parameter {
    apply_method = "pending-reboot"
    name         = "character_set_database"
    value        = "utf8mb4"
  }
  parameter {
    apply_method = "pending-reboot"
    name         = "character_set_results"
    value        = "utf8mb4"
  }
  parameter {
    apply_method = "pending-reboot"
    name         = "collation_connection"
    value        = "utf8mb4_unicode_ci"
  }
  parameter {
    apply_method = "pending-reboot"
    name         = "collation_server"
    value        = "utf8mb4_unicode_ci"
  }
  parameter {
    apply_method = "pending-reboot"
    name         = "innodb_flush_log_at_trx_commit"
    value        = "1"
  }
  parameter {
    apply_method = "pending-reboot"
    name         = "innodb_lock_wait_timeout"
    value        = "120"
  }
  parameter {
    apply_method = "pending-reboot"
    name         = "max_allowed_packet"
    value        = "157286400"
  }
  parameter {
    apply_method = "pending-reboot"
    name         = "thread_stack"
    value        = "6291456"
  }
  parameter {
    apply_method = "pending-reboot"
    name         = "group_concat_max_len"
    value        = "1000000"
  }
  parameter {
    apply_method = "pending-reboot"
    name         = "log_bin_trust_function_creators"
    value        = "1"
  }
}

resource "aws_security_group" "mysql_sg" {
  name        = "${var.environment}_mysql_sg"
  description = "CometML RDS cluster security group"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "mysql_port_inbound_ec2" {
  security_group_id            = aws_security_group.mysql_sg.id
  from_port                    = local.mysql_port
  to_port                      = local.mysql_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.rds_allow_from_sg
}
