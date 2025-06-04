###########################
#### AWS Resource Tags ####
###########################
# common_tags = {
#   # Place your dictionary of customized AWS resource tags here. eg.
#   Owner          = "firstName-lastName"
#   DeployedBy     = "Devops"
#   TTL            = "2025-01-01 12:00:00"
#   Customer       = "Model-Ops"
# }

# Deployment identifier
## Places an Environment tag on all resources created by this module
environment_tag = "deployment-development"

########################
#### Module toggles ####
########################
# Create a VPC to launch other resources in
enable_vpc = false

# Create an EC2 instance for running Comet
enable_ec2 = false

# Create an ALB for the Comet EC2 instance
enable_ec2_alb = false

# Create an EKS cluster for running Comet
enable_eks = false

# Create ElastiCache resources for running Comet Redis
enable_elasticache = false

# Create RDS resources for running Comet MySQL
enable_rds = false

# Create S3 resources for storing Comet objects
enable_s3 = false

# Create EKS nodegroups for MPM compute
enable_mpm_infra = false

################
#### Global ####
################
# Region to launch resources in
region = "us-east-1"

# Name for Comet environment, for use in resource naming
environment = "prod"

# If not setting enable_vpc to provision a VPC for the Comet resources, set the variables below to specify the existing VPC in which resources will be launched
comet_vpc_id          = "vpc-012345abcdefghijkl"
availability_zones    = ["us-east-1a", "us-east-1b", "us-east-1c"]
comet_public_subnets  = ["subnet-012345abcdefghijkl", "subnet-012345abcdefghijkl", "subnet-012345abcdefghijkl"]
comet_private_subnets = ["subnet-012345abcdefghijkl", "subnet-012345abcdefghijkl", "subnet-012345abcdefghijkl"]

#######################
#### Module inputs ####
#######################
## Required module inputs listed below. Any desired overrides from the defaults in variables.tf can also be added here

#### comet_ec2 ####
#

#### comet_ec2_alb ####
# If setting enable_ec2_alb, specify the ARN of an SSL certificate for the HTTPS listener
ssl_certificate_arn = null

#### comet_eks ####
eks_aws_cloudwatch_metrics = false

#### comet_elasticache ####
## If setting enable_elasticache with existing compute, set the variable below to specify an SG that connections will be allowed from
elasticache_allow_from_sg = "sg-012345abcdefghijkl"

## Set the following to enable the auth token for Redis
#elasticache_transit_encryption = true
#elasticache_auth_token = "your-cometml-redis-token"

#### comet_rds ####
## If setting enable_rds, specify the root password for RDS below, or leave null and enter at the prompt during apply
rds_root_password = null

## If setting enable_rds with existing compute, set the variable below to specify an SG that connections will be allowed from
rds_allow_from_sg = "sg-012345abcdefghijkl"

#### comet_s3 ####
## If setting enable_s3, specify the bucket name below
s3_bucket_name = null

#### comet_vpc ####
#
