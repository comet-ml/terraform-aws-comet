locals {
  tags = var.common_tags
  
  suffix = substr(sha1("${var.environment}"), 0, 8)
}

resource "aws_s3_bucket" "comet_s3_bucket" {
  bucket = var.comet_s3_bucket

  force_destroy = var.s3_force_destroy

  tags = merge(local.tags, {
    Name = var.comet_s3_bucket
  })
}

resource "aws_s3_bucket" "comet_druid_bucket" {
  count = var.enable_mpm_infra ? 1 : 0

  bucket = "comet-druid-${local.suffix}"

  force_destroy = var.s3_force_destroy

  tags = merge(local.tags, {
    Name = "comet-druid-${local.suffix}"
  })
}

resource "aws_s3_bucket" "comet_airflow_bucket" {
  count = var.enable_mpm_infra ? 1 : 0

  bucket = "comet-airflow-${local.suffix}"

  force_destroy = var.s3_force_destroy

  tags = merge(local.tags, {
    Name = "comet-airflow-${local.suffix}"
  })
}

resource "aws_iam_policy" "comet_s3_iam_policy" {
  name        = "comet-s3-access-policy-${local.suffix}"
  description = "Policy for access to comet S3 buckets"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "s3:*",
        Resource = concat(
          [
            aws_s3_bucket.comet_s3_bucket.arn,
            "${aws_s3_bucket.comet_s3_bucket.arn}/*"
          ],
          var.enable_mpm_infra ? [
            aws_s3_bucket.comet_druid_bucket[0].arn,
            "${aws_s3_bucket.comet_druid_bucket[0].arn}/*",
            aws_s3_bucket.comet_airflow_bucket[0].arn,
            "${aws_s3_bucket.comet_airflow_bucket[0].arn}/*"
          ] : []
        )
      }
    ]
  })
}