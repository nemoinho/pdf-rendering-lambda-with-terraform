terraform {
  backend "s3" {
    bucket         = "pdf-rendering-lambda-with-terraform-example-remote-state"
    dynamodb_table = "pdf-rendering-lambda-with-terraform-example-remote-state-lock"
    region         = "eu-central-1"
    key            = "dev/remote-state.tfstate"
    encrypt        = true
  }
}

provider "aws" {
  version = "2.39.0"
  region  = "eu-central-1"
}

data "terraform_remote_state" "global" {
  backend = "s3"

  config = {
    bucket = "pdf-rendering-lambda-with-terraform-example-remote-state"
    key    = "global/remote-state.tfstate"
    region = "eu-central-1"
  }
}
