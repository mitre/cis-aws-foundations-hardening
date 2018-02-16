data "aws_billing_service_account" "main" {}

output "aws_billing_service_account" {
  value = "${data.aws_billing_service_account.main.arn}"
}

resource "aws_s3_bucket" "billing_logs" {
  bucket_prefix = "${var.prefix}-my-billing-tf-test-bucket-"
  acl           = "private"
}

#   policy = <<POLICY
# {
#   "Id": "Policy",
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": [
#         "s3:GetBucketAcl", "s3:GetBucketPolicy"
#       ],
#       "Effect": "Allow",
#       "Resource": "arn:aws:s3:::my-billing-tf-test-bucket",
#       "Principal": {
#         "AWS": [
#           "${data.aws_billing_service_account.main.arn}"
#         ]
#       }
#     },
#     {
#       "Action": [
#         "s3:PutObject"
#       ],
#       "Effect": "Allow",
#       "Resource": "arn:aws:s3:::my-billing-tf-test-bucket/AWSLogs/*",
#       "Principal": {
#         "AWS": [
#           "${data.aws_billing_service_account.main.arn}"
#         ]
#       }
#     }
#   ]
# }
# POLICY
# }

