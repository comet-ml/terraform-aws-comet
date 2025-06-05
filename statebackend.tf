# Uncomment to use S3 backend for remote state
# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket"
#     key            = "path/to/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "your-lock-table"         # Optional: for state locking
#     encrypt        = true
#   }
# }