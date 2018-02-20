#======================================================#
#                 Recorder us-east-1
#======================================================#

resource "aws_iam_role" "config_recorder_role_east1" {
  name = "${var.prefix}-config-recorder-role-east1"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "attach_east1" {
  name       = "config-role-attachment"
  roles      = ["${aws_iam_role.config_recorder_role_east1.id}"]
  policy_arn = "${data.aws_iam_policy.AWSConfigRole.arn}"

  depends_on = [
    "aws_iam_role.config_recorder_role_east1",
    "data.aws_iam_policy.AWSConfigRole",
  ]
}

resource "aws_sns_topic" "config_sns_east1" {
  provider = "aws.east1"
  name     = "${var.prefix}-config-sns"
}

resource "aws_sqs_queue" "config_sqs_east1" {
  provider = "aws.east1"
  name     = "${var.prefix}-config-sqs"
}

resource "aws_sns_topic_subscription" "config_sns_subscription_east1" {
  provider  = "aws.east1"
  topic_arn = "${aws_sns_topic.config_sns_east1.arn}"
  protocol  = "sqs"
  endpoint  = "${aws_sqs_queue.config_sqs_east1.arn}"
}

resource "aws_iam_role_policy" "config_recorder_role_policy_east1" {
  provider   = "aws.east1"
  name       = "config-recorder-role-policy_east1"
  role       = "${aws_iam_role.config_recorder_role_east1.id}"
  depends_on = ["aws_iam_role.config_recorder_role_east1"]

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject*"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.config_delivery_bucket.bucket}/us-east-1/AWSLogs/${data.aws_caller_identity.creds.account_id}/*"
            ],
            "Condition": {
                "StringLike": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketAcl"
            ],
            "Resource": "arn:aws:s3:::${aws_s3_bucket.config_delivery_bucket.bucket}"
        },
        {
            "Effect": "Allow",
            "Action": "sns:Publish",
            "Resource": "${aws_sns_topic.config_sns_east1.arn}"
        }
    ]
}
POLICY
}

resource "aws_config_configuration_recorder_status" "config_recorder_status_east1" {
  provider   = "aws.east1"
  name       = "${aws_config_configuration_recorder.config_recorder_east1.name}"
  is_enabled = true
  depends_on = ["aws_config_delivery_channel.config_delivery_channel_east1"]
}

resource "aws_config_delivery_channel" "config_delivery_channel_east1" {
  provider       = "aws.east1"
  name           = "default"
  s3_bucket_name = "${aws_s3_bucket.config_delivery_bucket.bucket}"

  s3_key_prefix = "us-east-1"
  sns_topic_arn = "${aws_sns_topic.config_sns_east1.arn}"
  depends_on    = ["aws_config_configuration_recorder.config_recorder_east1"]
}

resource "aws_config_configuration_recorder" "config_recorder_east1" {
  provider = "aws.east1"
  name     = "default"
  role_arn = "${aws_iam_role.config_recorder_role_east1.arn}"

  recording_group = {
    all_supported                 = true
    include_global_resource_types = true
  }
}
