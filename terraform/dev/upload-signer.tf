data "aws_s3_bucket_object" "upload_signer_deployment_package" {
  bucket = data.terraform_remote_state.global.outputs.lamba_artifacts_bucket_name
  key = "upload-signer.zip.base64sha256"
}

module "upload_signer" {
  source = "../modules/upload-signer"

  deployment_package_bucket = data.terraform_remote_state.global.outputs.lamba_artifacts_bucket_name
  deployment_package_key = "upload-signer.zip"
  deployment_package_hash = data.aws_s3_bucket_object.upload_signer_deployment_package.body
  environment = local.environment
  templates_bucket_name = module.templates_bucket.templates_bucket_name
  templates_bucket_region = module.templates_bucket.templates_bucket_region
}
