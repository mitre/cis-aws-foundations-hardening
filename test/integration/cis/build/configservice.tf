#======================================================#
#              Bucket for ConfigService
#======================================================#

resource "aws_s3_bucket" "config_delivery_bucket" {
  bucket_prefix = "${var.prefix}-config-delivery-bucket-"
  force_destroy = true
}

#======================================================#
#              ConfigServiceRole Policy 
#======================================================#

data "aws_iam_policy" "AWSConfigRole" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}
