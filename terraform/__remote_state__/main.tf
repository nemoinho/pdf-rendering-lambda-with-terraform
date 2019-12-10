terraform {
  backend "local" {}
}

provider "aws" {
  version = "2.39.0"
  region  = "eu-central-1"
}
