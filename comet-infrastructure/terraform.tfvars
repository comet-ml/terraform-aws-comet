enable_vpc         = false
enable_ec2         = false
enable_ec2_alb     = false
enable_eks         = false
enable_elasticache = false
enable_rds         = false
enable_s3          = false

region      = "us-east-1"
environment = "prod"

# if not using comet_vpc to provision a VPC for the Comet resources, set the variables below to specify the existing VPC
comet_vpc_id          = "vpc-012345abcdefghijkl"
availability_zones    = ["us-east-1a", "us-east-1b", "us-east-1c"]
comet_public_subnets  = ["subnet-012345abcdefghijkl", "subnet-012345abcdefghijkl", "subnet-012345abcdefghijkl"]
comet_private_subnets = ["subnet-012345abcdefghijkl", "subnet-012345abcdefghijkl", "subnet-012345abcdefghijkl"]

# if provisioning comet_elasticache for use with existing compute, set the variable below to specify an SG that connections will be allowed from
elasticache_allow_from_sg = "sg-012345abcdefghijkl"

# if provisioning comet_rds for use with existing compute, set the variable below to specify an SG that connections will be allowed from
rds_allow_from_sg = "sg-012345abcdefghijkl"

s3_bucket_name      = "comet-use2-bucket"
rds_root_password   = "CHANGE-ME"
ssl_certificate_arn = ""