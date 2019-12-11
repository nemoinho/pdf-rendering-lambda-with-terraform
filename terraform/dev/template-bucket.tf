module "templates_bucket" {
  source = "../modules/templates-bucket"

  environment = local.environment
}
