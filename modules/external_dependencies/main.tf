# add locals for repeated usage of redis and mysql ports; tags that are shared across resources
locals {
  redis_port = 6379
  mysql_port = 3306

  tags = {
    Terraform_Managed   = "true"
    Environment = var.environment
  }
}

resource "aws_elasticache_cluster" "comet-ml-ec-redis" {
  cluster_id           = "cometml-ec_redis-${var.environment}"
  engine               = var.elasticcache_engine
  node_type            = var.elasticache_redis_instance_type
  num_cache_nodes      = var.elasticcache_num_cache_nodes
  parameter_group_name = var.elasticcache_param_group_name
  engine_version       = var.elasticcache_engine_version
  port                 = local.redis_port
  subnet_group_name    = aws_elasticache_subnet_group.comet-ml-ec-subnet-group.name
  # SG resource ref
  security_group_ids   = [aws_security_group.redis_inbound_sg.id]
}

resource "aws_elasticache_subnet_group" "comet-ml-ec-subnet-group" {
  name       = "cometml-ec_sng-${var.environment}"
  # VPC module output ref
  subnet_ids = var.vpc_private_subnets
}

resource "aws_security_group" "redis_inbound_sg" {
  name        = "cometml-redis_in_sg-${var.environment}"
  description = "Redis Security Group"
  # VPC module output ref
  vpc_id      = var.vpc_id

  ingress {
    from_port       = local.redis_port
    to_port         = local.redis_port
    protocol        = "tcp"
    # SG resource ref
    # security groups need to change depending on whether Cx is using eks or ec2 deployment
    security_groups = [aws_security_group.worker_group_mgmt_one.id]
  }
}

resource "aws_security_group" "aurora_inbound_sg" {
  name        = "${var.environment}-aurora_inbound_sg"
  description = "Aurora Mysql RDS Security Group"
  # VPC module output ref
  vpc_id      = var.vpc_id

  ingress {
    from_port       = local.mysql_port
    to_port         = local.mysql_port
    protocol        = "tcp"
    # SG resource ref
    # security groups need to change depending on whether Cx is using eks or ec2 deployment
    security_groups = [aws_security_group.worker_group_mgmt_one.id]
  }
}

resource "aws_db_subnet_group" "comet-ml-rds-subnet" {
  name       = "cometml-rds_sgn-${var.environment}"
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
  cluster_identifier        = "cometml-mysql_cluster-${var.environment}"
  db_subnet_group_name      = aws_db_subnet_group.comet-ml-rds-subnet.name
  # VPC module output ref
  availability_zones        = module.vpc.azs
  database_name             = "logger"
  storage_encrypted         = true
  iam_database_authentication_enabled = true
  master_username           = "root"
  master_password           = var.rds_root_password
  engine                    = var.rds_engine
  engine_version            = var.rds_engine_version
  backup_retention_period   = 7
  final_snapshot_identifier = "comet-ml-rds-backup-${var.environment}"
  preferred_backup_window   = "07:00-09:00"
  vpc_security_group_ids = [aws_security_group.aurora_inbound_sg.id]
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.comet-ml-cluster-pg.name
}

resource "aws_rds_cluster_parameter_group" "comet-ml-cluster-pg" {
  name        = "cometml-rds-cluster-pg-${var.environment}"
  family      = "aurora-mysql5.7"
  description = "Comet ML RDS cluster parameter group"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_connection"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_results"
    value = "utf8mb4"
  }
  parameter {
    name  = "collation_connection"
    value = "utf8mb4_unicode_ci"
  }
  parameter {
    name  = "collation_server"
    value = "utf8mb4_unicode_ci"
  }
  parameter {
    name  = "innodb_flush_log_at_trx_commit"
    value = "1"
  }
  parameter {
    name  = "innodb_lock_wait_timeout"
    value = "120"
  }
  parameter {
    name  = "max_allowed_packet"
    value = "157286400"
  }
  parameter {
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