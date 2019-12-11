terraform {
  backend "s3" {
    bucket         = "pdf-rendering-lambda-with-terraform-example-remote-state"
    dynamodb_table = "pdf-rendering-lambda-with-terraform-example-remote-state-lock"
    region         = "eu-central-1"
    key            = "global/remote-state.tfstate"
    encrypt        = true
  }
}

provider "aws" {
  version = "2.39.0"
  region  = "eu-central-1"
}
