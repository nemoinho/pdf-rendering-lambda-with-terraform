locals {
  templates_bucket = "pdf-rendering-lambda-with-terraform-example-${substr(var.environment, 0, 9)}-templates"
}
