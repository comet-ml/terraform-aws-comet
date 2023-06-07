# Comet Infrastructure Deployment: Terraform on AWS
Terraform module for deploying infrastructure components to run CometML

### Modules
**Root Configuration**

**comet_ec2**

**comet_ec2_alb**

**comet_eks**

**comet_elasticache**

**comet_rds**

**comet_s3**

### Deployment
**Prerequisites:**
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) installed
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) installed
  - Access to an AWS account and credentials that allow you to create resources
  - Ensure `AWS_ACCESS_KEY_ID` and `AWS_SECRET_KEY_ID` environment variables are set in your session
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) installed

**Infrastructure Deployment:**
- Clone the repository to your local machine: `git clone https://github.com/comet-ml/dply-terraform-aws.git`
- Move into the deployment directory: `cd dply-terraform-aws/comet-infrastructure`
- Initialize the directory: `terraform init`
- Within terraform.tfvars, set your module toggles to enable the desired infrastructure components and set any required environment variables
- Provision the resources: `terraform apply`

### Cleanup
- `terraform destroy`
