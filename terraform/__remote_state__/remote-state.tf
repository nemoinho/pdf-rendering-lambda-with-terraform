resource "aws_s3_bucket" "terraform_state" {
  bucket = local.remote_state_bucket

  force_destroy = false

  lifecycle { prevent_destroy = true }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = "Terraform Remote State"
    Environment = "Required Infrastructure"
    Stage       = "Terraform"
    Section     = "State"
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "${local.remote_state_bucket}-lock"
  hash_key       = "LockID"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle { prevent_destroy = true }

  tags = {
    Name        = "Terraform State Lock"
    Environment = "Required Infrastructure"
    Stage       = "Terraform"
    Section     = "State"
  }
}
