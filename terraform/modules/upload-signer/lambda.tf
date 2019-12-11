resource "aws_cloudwatch_log_group" "slack_lambda" {
  name = "/aws/lambda/${local.function_name}"

  retention_in_days = 3
}

resource "aws_lambda_function" "upload_signer" {
  function_name    = local.function_name
  handler          = "index.handler"
  role             = aws_iam_role.upload_signer_role.arn
  runtime          = "nodejs12.x"
  s3_bucket        = var.deployment_package_bucket
  s3_key           = var.deployment_package_key
  source_code_hash = var.deployment_package_hash

  environment {
    variables = {
      BUCKET_REGION = var.templates_bucket_region
      BUCKET        = var.templates_bucket_name
    }
  }
}
