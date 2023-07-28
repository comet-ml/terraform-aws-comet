## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 19.9 |
| <a name="module_eks_blueprints_addons"></a> [eks\_blueprints\_addons](#module\_eks\_blueprints\_addons) | aws-ia/eks-blueprints-addons/aws | 0.2.0 |
| <a name="module_irsa-ebs-csi"></a> [irsa-ebs-csi](#module\_irsa-ebs-csi) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | 4.7.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.ebs_csi_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_comet_ec2_s3_iam_policy"></a> [comet\_ec2\_s3\_iam\_policy](#input\_comet\_ec2\_s3\_iam\_policy) | Policy with access to S3 to associate with EKS worker nodes | `string` | `null` | no |
| <a name="input_eks_aws_cloudwatch_metrics"></a> [eks\_aws\_cloudwatch\_metrics](#input\_eks\_aws\_cloudwatch\_metrics) | Enables AWS Cloudwatch Metrics in the EKS cluster | `bool` | n/a | yes |
| <a name="input_eks_aws_load_balancer_controller"></a> [eks\_aws\_load\_balancer\_controller](#input\_eks\_aws\_load\_balancer\_controller) | Enables the AWS Load Balancer Controller in the EKS cluster | `bool` | n/a | yes |
| <a name="input_eks_cert_manager"></a> [eks\_cert\_manager](#input\_eks\_cert\_manager) | Enables cert-manager in the EKS cluster | `bool` | n/a | yes |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | Name for the EKS cluster | `string` | n/a | yes |
| <a name="input_eks_cluster_version"></a> [eks\_cluster\_version](#input\_eks\_cluster\_version) | Kubernetes version for the EKS cluster | `string` | n/a | yes |
| <a name="input_eks_external_dns"></a> [eks\_external\_dns](#input\_eks\_external\_dns) | Enables ExternalDNS in the EKS cluster | `bool` | n/a | yes |
| <a name="input_eks_mng_ami_type"></a> [eks\_mng\_ami\_type](#input\_eks\_mng\_ami\_type) | AMI family to use for the EKS nodes | `string` | n/a | yes |
| <a name="input_eks_mng_desired_size"></a> [eks\_mng\_desired\_size](#input\_eks\_mng\_desired\_size) | Desired number of nodes in EKS cluster | `number` | n/a | yes |
| <a name="input_eks_mng_max_size"></a> [eks\_mng\_max\_size](#input\_eks\_mng\_max\_size) | Maximum number of nodes in EKS cluster | `number` | n/a | yes |
| <a name="input_eks_mng_name"></a> [eks\_mng\_name](#input\_eks\_mng\_name) | Name for the EKS managed nodegroup | `string` | n/a | yes |
| <a name="input_eks_node_types"></a> [eks\_node\_types](#input\_eks\_node\_types) | Node instance types for EKS managed node group | `list(string)` | n/a | yes |
| <a name="input_eks_private_subnets"></a> [eks\_private\_subnets](#input\_eks\_private\_subnets) | IDs of private subnets within the VPC | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment, i.e. dev/stage/prod, etc | `string` | n/a | yes |
| <a name="input_s3_enabled"></a> [s3\_enabled](#input\_s3\_enabled) | Indicates if S3 bucket is being provisioned for Comet | `bool` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC that the EKS cluster will be launched in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | n/a |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | n/a |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
| <a name="output_nodegroup_sg_id"></a> [nodegroup\_sg\_id](#output\_nodegroup\_sg\_id) | n/a |
