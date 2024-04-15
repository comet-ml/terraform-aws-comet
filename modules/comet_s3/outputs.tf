output "comet_s3_iam_policy_arn" {
  description = "ARN of the IAM policy granting access to the provisioned bucket(s)"
  value       = aws_iam_policy.comet_s3_iam_policy.arn
}