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
| [aws_elasticache_cluster.comet-ml-ec-redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_elasticache_subnet_group.comet-ml-ec-subnet-group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_security_group.redis_inbound_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_ingress_rule.redis_port_inbound_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_elasticache_allow_from_sg"></a> [elasticache\_allow\_from\_sg](#input\_elasticache\_allow\_from\_sg) | Security group from which connections to ElastiCache will be allowed | `string` | n/a | yes |
| <a name="input_elasticache_engine"></a> [elasticache\_engine](#input\_elasticache\_engine) | Engine type for Elasticache cluster | `string` | n/a | yes |
| <a name="input_elasticache_engine_version"></a> [elasticache\_engine\_version](#input\_elasticache\_engine\_version) | Version number for Elasticache engine | `string` | n/a | yes |
| <a name="input_elasticache_instance_type"></a> [elasticache\_instance\_type](#input\_elasticache\_instance\_type) | Elasticache instance type | `string` | n/a | yes |
| <a name="input_elasticache_num_cache_nodes"></a> [elasticache\_num\_cache\_nodes](#input\_elasticache\_num\_cache\_nodes) | Number of nodes in the Elasticache cluster | `number` | n/a | yes |
| <a name="input_elasticache_param_group_name"></a> [elasticache\_param\_group\_name](#input\_elasticache\_param\_group\_name) | Name for the Elasticache cluster parameter group | `string` | n/a | yes |
| <a name="input_elasticache_private_subnets"></a> [elasticache\_private\_subnets](#input\_elasticache\_private\_subnets) | IDs of private subnets within the VPC | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment, i.e. dev/stage/prod, etc | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC that will contain the provisioned resources | `string` | n/a | yes |

## Outputs

No outputs.
