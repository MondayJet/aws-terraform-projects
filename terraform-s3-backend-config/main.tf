provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "jet-bucket-12345"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.terraform_state.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name = "jet-bucket-12345-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

###3 You must have created the above infrastructure before adding the infrastructure below

terraform {
  backend "s3" {
    bucket = "jet-bucket-12345"  #Replace with your bucket Name
    key = "global/s3/terraform.tfstate"
    region = "us-east-1"

    use_lockfile = true
    encrypt = true
  }
}

### Initializint the above cause the state file to be stored in the s3 bucket

## To further see the backend in action

output "s3_bucket_arn" {
value = aws_s3_bucket.terraform_state.arn
description = "The ARN of the S3 bucket"
}
output "dynamodb_table_name" {
value = aws_dynamodb_table.terraform_locks.name
description = "The name of the DynamoDB table"
}

# Limitations with Terraforms Backends
# To make this work, you had to use a two-step process:

# 1. Write Terraform code to create the S3 bucket and
# DynamoDB table, and deploy that code with a local
# backend.

# 2. Go back to the Terraform code, add a remote backend
# configuration to it to use the newly created S3 bucket
# and DynamoDB table, and run terraform init to copy
# your local state to S3.

################################################################################
# If you ever wanted to delete the S3 bucket and DynamoDB
# table, you’d have to do this two-step process in reverse:

# 1. Go to the Terraform code, remove the backend
# configuration, and rerun terraform init to copy the
# Terraform state back to your local disk.

# 2. Run terraform destroy to delete the S3 bucket and
# DynamoDB table.