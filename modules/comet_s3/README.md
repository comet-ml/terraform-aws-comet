## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.comet_s3_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_s3_bucket.comet_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_comet_s3_bucket"></a> [comet\_s3\_bucket](#input\_comet\_s3\_bucket) | Name of S3 bucket | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment, i.e. dev/stage/prod, etc | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_comet_s3_iam_policy_arn"></a> [comet\_s3\_iam\_policy\_arn](#output\_comet\_s3\_iam\_policy\_arn) | ARN of the IAM policy granting access to the provisioned bucket |
