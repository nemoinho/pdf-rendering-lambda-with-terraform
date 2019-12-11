resource "aws_s3_bucket" "lambda_artifacts" {
  bucket = local.lambda_artifacts_bucket

  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    enabled = true
    id      = "delete old versions after 7 days"

    noncurrent_version_expiration { days = 7 }
  }

  tags = {
    Name        = "Codepipeline artifacts"
    Environment = "Required Infrastructure"
    Stage       = "Building Pipeline"
    Section     = "Caches"
  }
}

resource "aws_s3_bucket_public_access_block" "lambda_artifacts" {
  bucket = aws_s3_bucket.lambda_artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
