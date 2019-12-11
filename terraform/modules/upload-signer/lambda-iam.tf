data "aws_caller_identity" "current" {}

resource "aws_iam_role" "upload_signer_role" {
  name               = local.function_role_name
  assume_role_policy = data.aws_iam_policy_document.upload_signer_role_assume_policy_document.json
}

resource "aws_iam_role_policy" "upload_signer_role_policy" {
  role   = aws_iam_role.upload_signer_role.id
  name   = local.function_role_policy_name
  policy = data.aws_iam_policy_document.upload_signer_role_policy_document.json
}

data "aws_iam_policy_document" "upload_signer_role_assume_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "upload_signer_role_policy_document" {
  statement {
    actions = ["logs:CreateLogStream"]
    resources = ["arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.slack_lambda.name}:log-stream:*"]
  }
  statement {
    actions = ["logs:PutLogEvents"]
    resources = ["arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.slack_lambda.name}:log-stream:*"]
  }
  statement {
    actions = ["s3:PutObject"]
    resources = [local.templates_bucket_arn]
  }
}
