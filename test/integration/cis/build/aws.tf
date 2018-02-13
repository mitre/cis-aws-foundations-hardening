terraform {
  required_version = "~> 0.10.0"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
  version    = "~> 1.4"
}

data "aws_caller_identity" "creds" {}

output "aws_account_id" {
  value = "${data.aws_caller_identity.creds.account_id}"
}

data "aws_region" "region" {
  current = true
}

output "aws_region" {
  value = "${data.aws_region.region.name}"
}
