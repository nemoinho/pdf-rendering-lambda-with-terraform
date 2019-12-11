locals {
  function_name             = "${substr(var.environment, 0, 50)}-upload-signer"
  function_role_name        = "${substr(local.function_name, 0, 59)}-role"
  function_role_policy_name = "${substr(local.function_role_name, 0, 121)}-policy"
  templates_bucket_arn      = "arn:aws:s3:::${var.templates_bucket_name}/*"
}
