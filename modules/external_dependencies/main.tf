# add locals for repeated usage of redis and mysql ports; tags that are shared across resources
locals {
  redis_port = 6379
  mysql_port = 3306

  tags = {
    Terraform_Managed = "true"
    Environment       = var.environment
  }
}

resource "aws_elasticache_cluster" "comet-ml-ec-redis" {
  cluster_id           = "cometml-ec-redis-${var.environment}"
  engine               = var.elasticcache_engine
  node_type            = var.elasticache_redis_instance_type
  num_cache_nodes      = var.elasticcache_num_cache_nodes
  parameter_group_name = var.elasticcache_param_group_name
  engine_version       = var.elasticcache_engine_version
  port                 = local.redis_port
  subnet_group_name    = aws_elasticache_subnet_group.comet-ml-ec-subnet-group.name
  # SG resource ref
  security_group_ids = [aws_security_group.redis_inbound_sg.id]
}

resource "aws_elasticache_subnet_group" "comet-ml-ec-subnet-group" {
  name = "cometml-ec-sng-${var.environment}"
  # VPC module output ref
  subnet_ids = var.vpc_private_subnets
}

resource "aws_security_group" "redis_inbound_sg" {
  name        = "cometml_redis_in_sg_${var.environment}"
  description = "Redis Security Group"
  # VPC module output ref
  vpc_id = var.vpc_id

  /* move to separate resource
  ingress {
    from_port = local.redis_port
    to_port   = local.redis_port
    protocol  = "tcp"
    # SG resource ref
    # security groups need to change depending on whether Cx is using eks or ec2 deployment
    security_groups = [var.elasticcache_rds_allowfrom_sg]
  }
  */
}

resource "aws_vpc_security_group_ingress_rule" "redis_port_inbound_allow" {
  security_group_id = aws_security_group.redis_inbound_sg.id

  from_port   = local.redis_port
  to_port     = local.redis_port
  ip_protocol    = "tcp"
  # security groups need to change depending on whether Cx is using eks or ec2 deployment; hard-coded index won't work
  referenced_security_group_id = var.elasticcache_rds_allowfrom_sg
}

resource "aws_security_group" "aurora_inbound_sg" {
  name        = "${var.environment}_aurora_inbound_sg"
  description = "Aurora Mysql RDS Security Group"
  # VPC module output ref
  vpc_id = var.vpc_id

  /* move to separate resource
  ingress {
    from_port = local.mysql_port
    to_port   = local.mysql_port
    protocol  = "tcp"
    # SG resource ref
    # security groups need to change depending on whether Cx is using eks or ec2 deployment
    security_groups = [var.elasticcache_rds_allowfrom_sg]
  }
  */
}

resource "aws_vpc_security_group_ingress_rule" "aurora_port_inbound_allow" {
  security_group_id = aws_security_group.aurora_inbound_sg.id

  from_port   = local.mysql_port
  to_port     = local.mysql_port
  ip_protocol    = "tcp"
  # security groups need to change depending on whether Cx is using eks or ec2 deployment; hard-coded index won't work
  referenced_security_group_id = var.elasticcache_rds_allowfrom_sg
}

resource "aws_db_subnet_group" "comet-ml-rds-subnet" {
  name = "cometml_rds_sgn_${var.environment}"
  # VPC module output ref
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
  # VPC module output ref
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

resource "aws_s3_bucket" "s3-comet-ml" {
  bucket = var.comet_ml_s3_bucket

  # server_side_encryption_configuration {
  #  rule {
  #    apply_server_side_encryption_by_default {
  #        sse_algorithm     = "aws:kms"
  #    }
  #  }
  # }

  tags = merge(local.tags, {
    Name = var.comet_ml_s3_bucket
  })
}