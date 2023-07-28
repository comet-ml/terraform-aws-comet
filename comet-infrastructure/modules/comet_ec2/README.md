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
| [aws_eip.comet_ec2_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.comet-ec2-instance-profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.comet-ec2-s3-access-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.comet-ml-s3-access-attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.comet_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.comet_ec2_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.comet_ec2_egress_any](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.comet_ec2_alb_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.comet_ec2_ingress_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.comet_ec2_ingress_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.comet_ec2_ingress_ssh](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_ami.al2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.rhel7](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.rhel8](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.rhel9](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.ubuntu18](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.ubuntu20](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.ubuntu22](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_enabled"></a> [alb\_enabled](#input\_alb\_enabled) | Indicates if ALB is being provisioned for Comet EC2 instance | `bool` | `null` | no |
| <a name="input_comet_ec2_alb_sg"></a> [comet\_ec2\_alb\_sg](#input\_comet\_ec2\_alb\_sg) | ID of the security group attached to an associated application load balancer, for creating ingress EC2 SG rule | `string` | n/a | yes |
| <a name="input_comet_ec2_ami_type"></a> [comet\_ec2\_ami\_type](#input\_comet\_ec2\_ami\_type) | Operating system type for the EC2 instance AMI | `string` | n/a | yes |
| <a name="input_comet_ec2_instance_count"></a> [comet\_ec2\_instance\_count](#input\_comet\_ec2\_instance\_count) | Number of EC2 instances to provision | `number` | n/a | yes |
| <a name="input_comet_ec2_instance_type"></a> [comet\_ec2\_instance\_type](#input\_comet\_ec2\_instance\_type) | Instance type for the EC2 instance | `string` | n/a | yes |
| <a name="input_comet_ec2_key"></a> [comet\_ec2\_key](#input\_comet\_ec2\_key) | Name of the SSH key to configure on the EC2 instance | `string` | n/a | yes |
| <a name="input_comet_ec2_s3_iam_policy"></a> [comet\_ec2\_s3\_iam\_policy](#input\_comet\_ec2\_s3\_iam\_policy) | Policy granting access to Comet S3 bucket | `string` | n/a | yes |
| <a name="input_comet_ec2_subnet"></a> [comet\_ec2\_subnet](#input\_comet\_ec2\_subnet) | ID of VPC subnet to launch EC2 instance in | `string` | n/a | yes |
| <a name="input_comet_ec2_volume_size"></a> [comet\_ec2\_volume\_size](#input\_comet\_ec2\_volume\_size) | Size, in gibibytes (GiB), for the EC2 instance root volume | `number` | n/a | yes |
| <a name="input_comet_ec2_volume_type"></a> [comet\_ec2\_volume\_type](#input\_comet\_ec2\_volume\_type) | EBS volume type for the EC2 instance root volume | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment, i.e. dev/stage/prod, etc | `string` | `"dev"` | no |
| <a name="input_s3_enabled"></a> [s3\_enabled](#input\_s3\_enabled) | Indicates if S3 bucket is being provisioned for Comet | `bool` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC that will contain the provisioned resources | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_comet_ec2_instance_id"></a> [comet\_ec2\_instance\_id](#output\_comet\_ec2\_instance\_id) | ID of the EC2 instance |
| <a name="output_comet_ec2_public_ip"></a> [comet\_ec2\_public\_ip](#output\_comet\_ec2\_public\_ip) | Public IP of the EIP associated with the EC2 instance |
| <a name="output_comet_ec2_sg_id"></a> [comet\_ec2\_sg\_id](#output\_comet\_ec2\_sg\_id) | ID of the security group associated with the EC2 instance |