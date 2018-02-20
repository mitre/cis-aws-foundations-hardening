terraform {
  required_version = "> 0.10.0"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
  version    = "~> 1.4"
}

data "aws_caller_identity" "creds" {}

data "aws_region" "region" {}

provider "aws" {
  alias  = "east1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "east2"
  region = "us-east-2"
}

provider "aws" {
  alias  = "west1"
  region = "us-west-1"
}

provider "aws" {
  alias  = "west2"
  region = "us-west-2"
}
