locals {
  ssh_port      = 22
  http_port     = 80
  any_port      = 0
  cidr_anywhere = "0.0.0.0/0"

  tags = {
    Terraform_Managed = "true"
    Environment       = var.environment
  }
}

resource "aws_instance" "comet_ec2" {
  ami           = var.comet_ec2_ami
  instance_type = var.comet_ec2_instance_type
  key_name      = var.key_name
  count         = var.comet_ec2_instance_count
  iam_instance_profile = aws_iam_instance_profile.comet-ec2-instance-profile.name
  subnet_id     = var.comet_ec2_subnet
  
  # need enable multiple SGs
  vpc_security_group_ids = [aws_security_group.comet_ec2_sg.id]

  root_block_device {
    volume_type = var.comet_ec2_volume_type
    volume_size = var.comet_ec2_volume_size
  }
  
  tags = merge(local.tags, {
    Name = "${var.environment}-comet-ml-${count.index}"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "comet_ec2_sg" {
  name        = "comet_${var.environment}_ec2_sg"
  description = "Comet EC2 instance security group"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "comet_ec2_ingress_ssh" {
  security_group_id = aws_security_group.comet_ec2_sg.id
  
  from_port   = local.ssh_port
  to_port     = local.ssh_port
  ip_protocol    = "tcp"
  # make more restrictive
  cidr_ipv4 = local.cidr_anywhere
}

resource "aws_vpc_security_group_ingress_rule" "comet_ec2_ingress_http" {
  security_group_id = aws_security_group.comet_ec2_sg.id
  
  from_port   = local.http_port
  to_port     = local.http_port
  ip_protocol    = "tcp"
  # make more restrictive
  cidr_ipv4 = local.cidr_anywhere
}

/* SG rule to allow ingress from LB SG; add later
resource "aws_vpc_security_group_ingress_rule" "comet_ec2_ingress_http" {
  security_group_id = aws_security_group.comet_ec2_sg.id
  
  from_port   = local.http_port
  to_port     = local.http_port
  ip_protocol    = "tcp"
  security_groups = [aws_security_group.lb_inbound_sg.id]
}
*/

resource "aws_vpc_security_group_egress_rule" "comet_ec2_egress_any" {
  security_group_id = aws_security_group.comet_ec2_sg.id
  ip_protocol    = "-1"
  cidr_ipv4 = local.cidr_anywhere
}

resource "aws_iam_role" "comet-ec2-s3-access-role" {
  name               = "comet-ml-s3-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  })
}

resource "aws_iam_instance_profile" "comet-ec2-instance-profile" {
  name  = "${var.environment}-comet-ec2-instance-profile"
  role  = aws_iam_role.comet-ec2-s3-access-role.name
}

resource "aws_iam_role_policy_attachment" "comet-ml-s3-access-attachment" {
  count      = var.s3_enabled ? 1 : 0
  role       = aws_iam_role.comet-ec2-s3-access-role.name
  policy_arn = var.comet_ec2_s3_iam_policy
}