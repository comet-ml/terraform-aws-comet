locals {
  ssh_port      = 22
  http_port     = 80
  https_port    = 443
  any_port      = 0
  cidr_anywhere = "0.0.0.0/0"
}

data "aws_ami" "al2023" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["137112412989"] # Amazon official
}

data "aws_ami" "al2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["amazon"]
}

data "aws_ami" "rhel7" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-7*_HVM-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["amazon"]
}

data "aws_ami" "rhel8" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-8*_HVM-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["amazon"]
}

data "aws_ami" "rhel9" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-9*_HVM-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["amazon"]
}

data "aws_ami" "ubuntu20" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-20.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["amazon"]
}

data "aws_ami" "ubuntu22" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "comet_ec2" {
  ami = var.comet_ec2_ami_id != "" ? var.comet_ec2_ami_id : (
    var.comet_ec2_ami_type == "al2023" ? data.aws_ami.al2023.id : (
      var.comet_ec2_ami_type == "al2" ? data.aws_ami.al2.id : (
        var.comet_ec2_ami_type == "rhel7" ? data.aws_ami.rhel7.id : (
          var.comet_ec2_ami_type == "rhel8" ? data.aws_ami.rhel8.id : (
            var.comet_ec2_ami_type == "rhel9" ? data.aws_ami.rhel9.id : (
              var.comet_ec2_ami_type == "ubuntu20" ? data.aws_ami.ubuntu20.id : (
                var.comet_ec2_ami_type == "ubuntu22" ? data.aws_ami.ubuntu22.id : (
  null))))))))
  instance_type          = var.comet_ec2_instance_type
  key_name               = var.comet_ec2_key
  count                  = var.comet_ec2_instance_count
  iam_instance_profile   = aws_iam_instance_profile.comet-ec2-instance-profile.name
  subnet_id              = var.comet_ec2_subnet
  vpc_security_group_ids = [aws_security_group.comet_ec2_sg.id]

  #associate_public_ip_address = true

  root_block_device {
    volume_type = var.comet_ec2_volume_type
    volume_size = var.comet_ec2_volume_size
    tags        = var.common_tags
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-comet-ml-${count.index}"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "comet_ec2_eip" {
  count    = var.alb_enabled ? 0 : 1
  instance = aws_instance.comet_ec2[0].id
  domain   = "vpc"
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
  ip_protocol = "tcp"
  cidr_ipv4   = local.cidr_anywhere
}

resource "aws_vpc_security_group_ingress_rule" "comet_ec2_ingress_http" {
  security_group_id = aws_security_group.comet_ec2_sg.id

  from_port   = local.http_port
  to_port     = local.http_port
  ip_protocol = "tcp"
  cidr_ipv4   = local.cidr_anywhere
}

resource "aws_vpc_security_group_ingress_rule" "comet_ec2_ingress_https" {
  security_group_id = aws_security_group.comet_ec2_sg.id

  from_port   = local.https_port
  to_port     = local.https_port
  ip_protocol = "tcp"
  cidr_ipv4   = local.cidr_anywhere
}

resource "aws_vpc_security_group_ingress_rule" "comet_ec2_alb_http" {
  count             = var.alb_enabled ? 1 : 0
  security_group_id = aws_security_group.comet_ec2_sg.id

  from_port                    = local.http_port
  to_port                      = local.http_port
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.comet_ec2_alb_sg
}

resource "aws_vpc_security_group_egress_rule" "comet_ec2_egress_any" {
  security_group_id = aws_security_group.comet_ec2_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = local.cidr_anywhere
}

resource "aws_iam_role" "comet-ec2-s3-access-role" {
  name = "comet-ml-s3-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_instance_profile" "comet-ec2-instance-profile" {
  name = "${var.environment}-comet-ec2-instance-profile"
  role = aws_iam_role.comet-ec2-s3-access-role.name
}

resource "aws_iam_role_policy_attachment" "comet-ml-s3-access-attachment" {
  count      = var.s3_enabled ? 1 : 0
  role       = aws_iam_role.comet-ec2-s3-access-role.name
  policy_arn = var.comet_ec2_s3_iam_policy
}