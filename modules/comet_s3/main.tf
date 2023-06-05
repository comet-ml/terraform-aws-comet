locals {
  tags = {
    Terraform_Managed = "true"
    Environment       = var.environment
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