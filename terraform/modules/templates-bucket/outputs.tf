output "templates_bucket_name" {
  value = aws_s3_bucket.templates.bucket
}

output "templates_bucket_region" {
  value = aws_s3_bucket.templates.region
}
