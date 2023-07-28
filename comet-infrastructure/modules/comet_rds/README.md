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
| [aws_db_subnet_group.comet-ml-rds-subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_rds_cluster.cometml-db-cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.comet-ml-rds-mysql](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_parameter_group.cometml-cluster-pg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |
| [aws_security_group.mysql_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_ingress_rule.mysql_port_inbound_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones from VPC | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment, i.e. dev/stage/prod, etc | `string` | n/a | yes |
| <a name="input_rds_allow_from_sg"></a> [rds\_allow\_from\_sg](#input\_rds\_allow\_from\_sg) | Security group from which to allow connections to RDS | `string` | n/a | yes |
| <a name="input_rds_backup_retention_period"></a> [rds\_backup\_retention\_period](#input\_rds\_backup\_retention\_period) | Days specified for RDS snapshotretention period | `number` | n/a | yes |
| <a name="input_rds_database_name"></a> [rds\_database\_name](#input\_rds\_database\_name) | Name for the application database in RDS | `string` | n/a | yes |
| <a name="input_rds_engine"></a> [rds\_engine](#input\_rds\_engine) | Engine type for RDS database | `string` | n/a | yes |
| <a name="input_rds_engine_version"></a> [rds\_engine\_version](#input\_rds\_engine\_version) | Engine version number for RDS database | `string` | n/a | yes |
| <a name="input_rds_iam_db_auth"></a> [rds\_iam\_db\_auth](#input\_rds\_iam\_db\_auth) | Enables IAM auth for the database in RDS | `bool` | n/a | yes |
| <a name="input_rds_instance_count"></a> [rds\_instance\_count](#input\_rds\_instance\_count) | Number of RDS instances in the database cluster | `number` | n/a | yes |
| <a name="input_rds_instance_type"></a> [rds\_instance\_type](#input\_rds\_instance\_type) | Instance type for RDS database | `string` | n/a | yes |
| <a name="input_rds_preferred_backup_window"></a> [rds\_preferred\_backup\_window](#input\_rds\_preferred\_backup\_window) | Backup window for RDS | `string` | n/a | yes |
| <a name="input_rds_private_subnets"></a> [rds\_private\_subnets](#input\_rds\_private\_subnets) | IDs of private subnets within the VPC | `list(string)` | n/a | yes |
| <a name="input_rds_root_password"></a> [rds\_root\_password](#input\_rds\_root\_password) | Root password for RDS database | `string` | n/a | yes |
| <a name="input_rds_storage_encrypted"></a> [rds\_storage\_encrypted](#input\_rds\_storage\_encrypted) | Enables encryption for RDS storage | `bool` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC that will contain the provisioned resources | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mysql_host"></a> [mysql\_host](#output\_mysql\_host) | MySQL endpoint |
