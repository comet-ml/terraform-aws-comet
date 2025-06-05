locals {
  http_port     = 80
  https_port    = 443
  any_port      = 0
  cidr_anywhere = "0.0.0.0/0"
}

resource "aws_security_group" "comet_alb_sg" {
  name        = "comet_${var.environment}_alb_sg"
  description = "Comet ALB security group"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "comet_ec2_alb_http" {
  security_group_id = aws_security_group.comet_alb_sg.id

  from_port   = local.http_port
  to_port     = local.http_port
  ip_protocol = "tcp"
  cidr_ipv4   = local.cidr_anywhere
}

resource "aws_vpc_security_group_ingress_rule" "comet_ec2_alb_https" {
  security_group_id = aws_security_group.comet_alb_sg.id

  from_port   = local.https_port
  to_port     = local.https_port
  ip_protocol = "tcp"
  cidr_ipv4   = local.cidr_anywhere
}

resource "aws_vpc_security_group_egress_rule" "comet_ec2_alb_egress" {
  security_group_id = aws_security_group.comet_alb_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = local.cidr_anywhere
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"
  tags    = var.common_tags

  name = "comet-${var.environment}-alb"

  load_balancer_type = "application"

  vpc_id          = var.vpc_id
  subnets         = var.public_subnets
  security_groups = [aws_security_group.comet_alb_sg.id]

  target_groups = [
    {
      name_prefix      = "comet-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = var.ssl_certificate_arn
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]
}