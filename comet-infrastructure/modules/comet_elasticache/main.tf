locals {
  redis_port = 6379

  tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

resource "aws_elasticache_cluster" "comet-ml-ec-redis" {
  cluster_id           = "cometml-ec-redis-${var.environment}"
  engine               = var.elasticache_engine
  node_type            = var.elasticache_instance_type
  num_cache_nodes      = var.elasticache_num_cache_nodes
  parameter_group_name = var.elasticache_param_group_name
  engine_version       = var.elasticache_engine_version
  port                 = local.redis_port
  subnet_group_name    = aws_elasticache_subnet_group.comet-ml-ec-subnet-group.name
  security_group_ids = [aws_security_group.redis_inbound_sg.id]
}

resource "aws_elasticache_subnet_group" "comet-ml-ec-subnet-group" {
  name = "cometml-ec-sng-${var.environment}"
  subnet_ids = var.elasticache_private_subnets
}

resource "aws_security_group" "redis_inbound_sg" {
  name        = "cometml_redis_in_sg_${var.environment}"
  description = "Redis Security Group"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "redis_port_inbound_rule" {
  security_group_id = aws_security_group.redis_inbound_sg.id

  from_port   = local.redis_port
  to_port     = local.redis_port
  ip_protocol    = "tcp"
  referenced_security_group_id = var.elasticache_allow_from_sg
}