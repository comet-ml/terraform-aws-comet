# Comet Infrastructure Deployment: Terraform on AWS
Terraform module for deploying infrastructure components to run CometML.

### Deployment
**Prerequisites:**
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) installed
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) installed
  - Access to an AWS account and credentials that allow you to create resources
  - Ensure `AWS_ACCESS_KEY_ID` and `AWS_SECRET_KEY_ID` environment variables are set in your session
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) installed

**Infrastructure Deployment:**
- Follow the steps below to deploy directly from the GitHub repository.
  - Clone the repository to your local machine: `git clone https://github.com/comet-ml/dply-terraform-aws.git`
  - Move into the deployment directory: `cd terraform-aws-comet`
  - Initialize the directory: `terraform init`
  - Within terraform.tfvars, set your module toggles to enable the desired infrastructure components and set any related inputs
  - Provision the resources: `terraform apply`

**A note on state management:**
- This configuration stores the Terraform state locally by default. To store the state file remotely in S3, a `backend` block can be nested within the `terraform` block inside versions.tf if applying directly from this configuration, or within your `terraform` block if calling the module. Below is an example of such a configuration:
```
terraform {
  backend "s3" {
    bucket = "mybucket"
    key    = "path/to/my/key"
    region = "us-east-1"
  }
}
```
- More on state management in S3 can be found [here](https://developer.hashicorp.com/terraform/language/settings/backends/s3)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.1 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~>2.10 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.21 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.8.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_comet_ec2"></a> [comet\_ec2](#module\_comet\_ec2) | ./modules/comet_ec2 | n/a |
| <a name="module_comet_ec2_alb"></a> [comet\_ec2\_alb](#module\_comet\_ec2\_alb) | ./modules/comet_ec2_alb | n/a |
| <a name="module_comet_eks"></a> [comet\_eks](#module\_comet\_eks) | ./modules/comet_eks | n/a |
| <a name="module_comet_elasticache"></a> [comet\_elasticache](#module\_comet\_elasticache) | ./modules/comet_elasticache | n/a |
| <a name="module_comet_rds"></a> [comet\_rds](#module\_comet\_rds) | ./modules/comet_rds | n/a |
| <a name="module_comet_s3"></a> [comet\_s3](#module\_comet\_s3) | ./modules/comet_s3 | n/a |
| <a name="module_comet_vpc"></a> [comet\_vpc](#module\_comet\_vpc) | ./modules/comet_vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_eks_cluster_auth.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of availability zones from region | `list(string)` | `null` | no |
| <a name="input_comet_ec2_ami_type"></a> [comet\_ec2\_ami\_type](#input\_comet\_ec2\_ami\_type) | Operating system type for the EC2 instance AMI | `string` | `"ubuntu22"` | no |
| <a name="input_comet_ec2_instance_count"></a> [comet\_ec2\_instance\_count](#input\_comet\_ec2\_instance\_count) | Number of EC2 instances to provision | `number` | `1` | no |
| <a name="input_comet_ec2_instance_type"></a> [comet\_ec2\_instance\_type](#input\_comet\_ec2\_instance\_type) | Instance type for the EC2 instance | `string` | `"m5.4xlarge"` | no |
| <a name="input_comet_ec2_key"></a> [comet\_ec2\_key](#input\_comet\_ec2\_key) | Name of the SSH key to configure on the EC2 instance | `string` | `null` | no |
| <a name="input_comet_ec2_volume_size"></a> [comet\_ec2\_volume\_size](#input\_comet\_ec2\_volume\_size) | Size, in gibibytes (GiB), for the EC2 instance root volume | `number` | `1024` | no |
| <a name="input_comet_ec2_volume_type"></a> [comet\_ec2\_volume\_type](#input\_comet\_ec2\_volume\_type) | EBS volume type for the EC2 instance root volume | `string` | `"gp2"` | no |
| <a name="input_comet_private_subnets"></a> [comet\_private\_subnets](#input\_comet\_private\_subnets) | List of private subnets IDs from existing VPC to provision resources in | `list(string)` | `null` | no |
| <a name="input_comet_public_subnets"></a> [comet\_public\_subnets](#input\_comet\_public\_subnets) | List of public subnets IDs from existing VPC to provision resources in | `list(string)` | `null` | no |
| <a name="input_comet_vpc_id"></a> [comet\_vpc\_id](#input\_comet\_vpc\_id) | ID of an existing VPC to provision resources in | `string` | `null` | no |
| <a name="input_eks_aws_cloudwatch_metrics"></a> [eks\_aws\_cloudwatch\_metrics](#input\_eks\_aws\_cloudwatch\_metrics) | Enables AWS Cloudwatch Metrics in the EKS cluster | `bool` | `true` | no |
| <a name="input_eks_aws_load_balancer_controller"></a> [eks\_aws\_load\_balancer\_controller](#input\_eks\_aws\_load\_balancer\_controller) | Enables the AWS Load Balancer Controller in the EKS cluster | `bool` | `true` | no |
| <a name="input_eks_cert_manager"></a> [eks\_cert\_manager](#input\_eks\_cert\_manager) | Enables cert-manager in the EKS cluster | `bool` | `true` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name for EKS cluster | `string` | `"comet-eks"` | no |
| <a name="input_eks_cluster_version"></a> [eks\_cluster\_version](#input\_eks\_cluster\_version) | Kubernetes version of the EKS cluster | `string` | `"1.26"` | no |
| <a name="input_eks_external_dns"></a> [eks\_external\_dns](#input\_eks\_external\_dns) | Enables ExternalDNS in the EKS cluster | `bool` | `true` | no |
| <a name="input_eks_mng_ami_type"></a> [eks\_mng\_ami\_type](#input\_eks\_mng\_ami\_type) | AMI family to use for the EKS nodes | `string` | `"AL2_x86_64"` | no |
| <a name="input_eks_mng_desired_size"></a> [eks\_mng\_desired\_size](#input\_eks\_mng\_desired\_size) | Desired number of nodes in EKS cluster | `number` | `3` | no |
| <a name="input_eks_mng_max_size"></a> [eks\_mng\_max\_size](#input\_eks\_mng\_max\_size) | Maximum number of nodes in EKS cluster | `number` | `6` | no |
| <a name="input_eks_mng_name"></a> [eks\_mng\_name](#input\_eks\_mng\_name) | Name for the EKS managed nodegroup | `string` | `"mng"` | no |
| <a name="input_eks_node_types"></a> [eks\_node\_types](#input\_eks\_node\_types) | Node instance types for EKS managed node group | `list(string)` | <pre>[<br>  "m5.4xlarge"<br>]</pre> | no |
| <a name="input_elasticache_allow_from_sg"></a> [elasticache\_allow\_from\_sg](#input\_elasticache\_allow\_from\_sg) | Security group from which to allow connections to ElastiCache, to use when provisioning with existing compute | `string` | `null` | no |
| <a name="input_elasticache_engine"></a> [elasticache\_engine](#input\_elasticache\_engine) | Engine type for ElastiCache cluster | `string` | `"redis"` | no |
| <a name="input_elasticache_engine_version"></a> [elasticache\_engine\_version](#input\_elasticache\_engine\_version) | Version number for ElastiCache engine | `string` | `"5.0.6"` | no |
| <a name="input_elasticache_instance_type"></a> [elasticache\_instance\_type](#input\_elasticache\_instance\_type) | ElastiCache instance type | `string` | `"cache.r4.xlarge"` | no |
| <a name="input_elasticache_num_cache_nodes"></a> [elasticache\_num\_cache\_nodes](#input\_elasticache\_num\_cache\_nodes) | Number of nodes in the ElastiCache cluster | `number` | `1` | no |
| <a name="input_elasticache_param_group_name"></a> [elasticache\_param\_group\_name](#input\_elasticache\_param\_group\_name) | Name for the ElastiCache cluster parameter group | `string` | `"default.redis5.0"` | no |
| <a name="input_enable_ec2"></a> [enable\_ec2](#input\_enable\_ec2) | Toggles the comet\_ec2 module, to provision EC2 resources for running Comet | `bool` | n/a | yes |
| <a name="input_enable_ec2_alb"></a> [enable\_ec2\_alb](#input\_enable\_ec2\_alb) | Toggles the comet\_ec2\_alb module, to provision an ALB in front of the EC2 instance | `bool` | n/a | yes |
| <a name="input_enable_eks"></a> [enable\_eks](#input\_enable\_eks) | Toggles the comet\_eks module, to provision EKS resources for running Comet | `bool` | n/a | yes |
| <a name="input_enable_elasticache"></a> [enable\_elasticache](#input\_enable\_elasticache) | Toggles the comet\_elasticache module for provisioning Comet Redis on elasticache | `bool` | n/a | yes |
| <a name="input_enable_rds"></a> [enable\_rds](#input\_enable\_rds) | Toggles the comet\_rds module for provisioning Comet RDS database | `bool` | n/a | yes |
| <a name="input_enable_s3"></a> [enable\_s3](#input\_enable\_s3) | Toggles the comet\_s3 module for provisioning Comet S3 bucket | `bool` | n/a | yes |
| <a name="input_enable_vpc"></a> [enable\_vpc](#input\_enable\_vpc) | Toggles the comet\_vpc module, to provision a new VPC for hosting the Comet resources | `bool` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment, i.e. dev/stage/prod, etc | `string` | `"dev"` | no |
| <a name="input_rds_allow_from_sg"></a> [rds\_allow\_from\_sg](#input\_rds\_allow\_from\_sg) | Security group from which to allow connections to RDS, to use when provisioning with existing compute | `string` | `null` | no |
| <a name="input_rds_backup_retention_period"></a> [rds\_backup\_retention\_period](#input\_rds\_backup\_retention\_period) | Days specified for RDS snapshotretention period | `number` | `7` | no |
| <a name="input_rds_database_name"></a> [rds\_database\_name](#input\_rds\_database\_name) | Name for the application database in RDS | `string` | `"logger"` | no |
| <a name="input_rds_engine"></a> [rds\_engine](#input\_rds\_engine) | Engine type for RDS database | `string` | `"aurora-mysql"` | no |
| <a name="input_rds_engine_version"></a> [rds\_engine\_version](#input\_rds\_engine\_version) | Engine version number for RDS database | `string` | `"5.7"` | no |
| <a name="input_rds_iam_db_auth"></a> [rds\_iam\_db\_auth](#input\_rds\_iam\_db\_auth) | Enables IAM auth for the database in RDS | `bool` | `true` | no |
| <a name="input_rds_instance_count"></a> [rds\_instance\_count](#input\_rds\_instance\_count) | Number of RDS instances in the database cluster | `number` | `2` | no |
| <a name="input_rds_instance_type"></a> [rds\_instance\_type](#input\_rds\_instance\_type) | Instance type for RDS database | `string` | `"db.r5.xlarge"` | no |
| <a name="input_rds_preferred_backup_window"></a> [rds\_preferred\_backup\_window](#input\_rds\_preferred\_backup\_window) | Backup window for RDS | `string` | `"07:00-09:00"` | no |
| <a name="input_rds_root_password"></a> [rds\_root\_password](#input\_rds\_root\_password) | Root password for RDS database | `string` | n/a | yes |
| <a name="input_rds_storage_encrypted"></a> [rds\_storage\_encrypted](#input\_rds\_storage\_encrypted) | Enables encryption for RDS storage | `bool` | `true` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region to provision resources in | `string` | n/a | yes |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | Name for S3 bucket | `string` | n/a | yes |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Controls whether single NAT gateway used for all public subnets | `bool` | `true` | no |
| <a name="input_ssl_certificate_arn"></a> [ssl\_certificate\_arn](#input\_ssl\_certificate\_arn) | ARN of the ACM certificate to use for the ALB | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_comet_alb_dns_name"></a> [comet\_alb\_dns\_name](#output\_comet\_alb\_dns\_name) | DNS name of the ALB fronting the Comet EC2 instance |
| <a name="output_comet_ec2_instance"></a> [comet\_ec2\_instance](#output\_comet\_ec2\_instance) | ID of the Comet EC2 instance |
| <a name="output_comet_ec2_public_ip"></a> [comet\_ec2\_public\_ip](#output\_comet\_ec2\_public\_ip) | EIP associated with the Comet EC2 instance |
| <a name="output_configure_kubectl"></a> [configure\_kubectl](#output\_configure\_kubectl) | Configure kubectl: run the following command to update your kubeconfig with the newly provisioned cluster. |
| <a name="output_mysql_host"></a> [mysql\_host](#output\_mysql\_host) | Endpoint for the RDS instance |
| <a name="output_region"></a> [region](#output\_region) | Region resources are provisioned in |
