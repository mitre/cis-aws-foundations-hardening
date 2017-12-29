resource "random_id" "bucket_id" {
  byte_length = 8
}

provider "aws" {
  version = "=1.1"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
}

resource "aws_instance" "example" {
  ami = "${var.aws_ami_id}"
  subnet_id = "${var.aws_subnet_id}"
  instance_type = "${var.aws_instance_type}"
  key_name = "${var.aws_ssh_key_name}"
  vpc_security_group_ids = ["${var.aws_security_group}"]
}

#============================================================#
#                      Security Groups
#============================================================#

# Look up the default VPC and the default security group for it
data "aws_vpc" "default" {
  default = "true"
}

data "aws_security_group" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
  name = "default"
}

output "ec2_security_group_default_vpc_id" {
  value = "${data.aws_vpc.default.id}"
}

output "ec2_security_group_default_group_id" {
  value = "${data.aws_security_group.default.id}"
}

# valid ACLs are Error: aws_s3_bucket_object.public: "acl" contains an invalid canned ACL type "public". V
#alid types are either "authenticated-read", "aws-exec-read", "bucket-owner-full-control", "bucket-owner-read",
# "private", "public-read", or "public-read-write"
