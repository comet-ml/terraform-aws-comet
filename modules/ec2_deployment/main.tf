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

resource "aws_instance" "allinone" {
  ami           = var.allinone_ami
  instance_type = var.allinone_instance_type
  key_name      = var.key_name
  count         = var.allinone_instance_count
  iam_instance_profile = aws_iam_instance_profile.comet-ml-s3-access-profile.name
  # Recommended place it in a private subnet along with a bastion host
  #subnet_id     = module.vpc.private_subnets[count.index % length(module.vpc.private_subnets)]
  subnet_id     = var.allinone_subnet
  
  # need enable multiple SGs
  vpc_security_group_ids = [aws_security_group.allinone_sg.id]

  root_block_device {
    volume_type = var.allinone_volume_type
    volume_size = var.allinone_volume_size
  }
  
  tags = merge(local.tags, {
    Name = "${var.environment}-comet-ml-${count.index}"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "allinone_sg" {
  name        = "${var.environment}-allinone_sg"
  description = "Comet.ML AllInOne Security Group"
  vpc_id      = var.vpc_id
  /* remove inline rules in favor of separate resource declarations
  ingress {
    from_port   = local.ssh_port
    to_port     = local.ssh_port
    protocol    = "tcp"
    # We recommend restricting that to your company IP or by Using a bastion host
    #security_groups = [aws_security_group.bastion_inbound_sg.id]
    cidr_blocks = [local.cidr_anywhere]

  }

  ingress {
    from_port   = local.http_port
    to_port     = local.http_port
    protocol    = "tcp"
    security_groups = [aws_security_group.lb_inbound_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.cidr_anywhere]
  }
  */
}

resource "aws_vpc_security_group_ingress_rule" "allinone_ingress_ssh" {
  security_group_id = aws_security_group.allinone_sg.id
  
  from_port   = local.ssh_port
  to_port     = local.ssh_port
  ip_protocol    = "tcp"
  # We recommend restricting that to your company IP or by Using a bastion host
  #security_groups = [aws_security_group.bastion_inbound_sg.id]
  cidr_ipv4 = local.cidr_anywhere
}

resource "aws_vpc_security_group_ingress_rule" "allinone_ingress_http" {
  security_group_id = aws_security_group.allinone_sg.id
  
  from_port   = local.http_port
  to_port     = local.http_port
  ip_protocol    = "tcp"
  # We recommend restricting that to your company IP or by Using a bastion host
  #security_groups = [aws_security_group.bastion_inbound_sg.id]
  cidr_ipv4 = local.cidr_anywhere
}

/* SG rule to allow ingress from LB SG; add later
resource "aws_vpc_security_group_ingress_rule" "allinone_ingress_http" {
  security_group_id = aws_security_group.allinone_sg.id
  
  from_port   = local.http_port
  to_port     = local.http_port
  ip_protocol    = "tcp"
  security_groups = [aws_security_group.lb_inbound_sg.id]
}
*/

resource "aws_vpc_security_group_egress_rule" "allinone_egress_any" {
  security_group_id = aws_security_group.allinone_sg.id
  /* no port ranges permitted when specifying all protocols
  from_port   = local.any_port
  to_port     = local.any_port
  */
  ip_protocol    = "-1"
  cidr_ipv4 = local.cidr_anywhere
}

resource "aws_iam_role" "comet-ml-allinone-s3-access-role" {
  name               = "comet-ml-s3-role"
  assume_role_policy = file("${path.module}/templates/assume-role.json")
}

resource "aws_iam_instance_profile" "comet-ml-s3-access-profile" {
  name  = "${var.environment}-comet-ml-s3-access-profile"
  role  = aws_iam_role.comet-ml-allinone-s3-access-role.name
}

resource "aws_iam_policy" "comet-ml-s3-policy" {
  name        = "comet-ml-s3-access-policy"
  description = "comet-ml-s3-access-policy"
  #policy = file("${path.module}/templates/s3bucketpolicy.json")
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource":"arn:aws:s3:::${var.comet_ml_s3_bucket}"
        }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "comet-ml-s3-access-attachment" {
    role       = aws_iam_role.comet-ml-allinone-s3-access-role.name
    policy_arn = aws_iam_policy.comet-ml-s3-policy.arn
}