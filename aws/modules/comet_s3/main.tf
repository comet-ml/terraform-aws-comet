locals {
  tags = {
    Terraform_Managed = "true"
    Environment       = var.environment
  }
}

resource "aws_s3_bucket" "comet_s3_bucket" {
  bucket = var.comet_s3_bucket

  tags = merge(local.tags, {
    Name = var.comet_s3_bucket
  })
}

resource "aws_iam_policy" "comet_s3_iam_policy" {
  name        = "comet-s3-access-policy"
  description = "comet-s3-access-policy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
              "arn:aws:s3:::${var.comet_s3_bucket}",
              "arn:aws:s3:::${var.comet_s3_bucket}/*"
            ]
        }
    ]
  })
}