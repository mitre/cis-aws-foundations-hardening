output "aws_account_id" {
  value = "${data.aws_caller_identity.creds.account_id}"
}

output "aws_region" {
  value = "${var.region}"
}

output "config_service" {
  value = "${
    map(
      "us-east-1" ,  map(
        "s3_bucket_name" , "${aws_s3_bucket.config_delivery_bucket.id}",
        "sns_topic_arn" , "${aws_sns_topic.config_sns_east1.arn}"
      ),
      "us-east-2" ,  map(
        "s3_bucket_name" , "${aws_s3_bucket.config_delivery_bucket.id}",
        "sns_topic_arn" , "${aws_sns_topic.config_sns_east2.arn}"

      ),
      "us-west-1" ,  map(
        "s3_bucket_name" , "${aws_s3_bucket.config_delivery_bucket.id}",
        "sns_topic_arn" , "${aws_sns_topic.config_sns_west1.arn}"

      ),
      "us-west-2" , map(
        "s3_bucket_name" , "${aws_s3_bucket.config_delivery_bucket.id}",
        "sns_topic_arn" , "${aws_sns_topic.config_sns_west2.arn}"

      )
    )
  }"
}

output "sns_topics" {
  value = "${
        map(
            "${aws_sns_topic.config_sns_east1.arn}" , "${map(
              "owner" , "${data.aws_caller_identity.creds.account_id}",
              "region" , "us-east-1",
            )}",
            "${aws_sns_topic.config_sns_east2.arn}" , "${map(
              "owner" , "${data.aws_caller_identity.creds.account_id}",
              "region" , "us-east-2",
            )}",
            "${aws_sns_topic.config_sns_west1.arn}" , "${map(
              "owner" , "${data.aws_caller_identity.creds.account_id}",
              "region" , "us-west-1",
            )}",
            "${aws_sns_topic.config_sns_west2.arn}" , "${map(
              "owner" , "${data.aws_caller_identity.creds.account_id}",
              "region" , "us-west-2",
            )}",
            "${aws_sns_topic.metric_sns.arn}" , "${map(
              "owner" , "${data.aws_caller_identity.creds.account_id}",
              "region" , "us-east-1",
            )}"
          )
        }"
}

output "sns_subscriptions" {
  value = "${
        map(
                "${aws_sns_topic_subscription.config_sns_subscription_east1.arn}" , "${map(
                  "endpoint" , "${aws_sns_topic_subscription.config_sns_subscription_east1.endpoint}",
                  "protocol" , "${aws_sns_topic_subscription.config_sns_subscription_east1.protocol}",
                  "owner" , "${data.aws_caller_identity.creds.account_id}",
                )}",
                "${aws_sns_topic_subscription.config_sns_subscription_east2.arn}" , "${map(
                  "endpoint" , "${aws_sns_topic_subscription.config_sns_subscription_east2.endpoint}",
                  "protocol" , "${aws_sns_topic_subscription.config_sns_subscription_east2.protocol}",
                  "owner" , "${data.aws_caller_identity.creds.account_id}",
                )}",
                "${aws_sns_topic_subscription.config_sns_subscription_west1.arn}" , "${map(
                  "endpoint" , "${aws_sns_topic_subscription.config_sns_subscription_west1.endpoint}",
                  "protocol" , "${aws_sns_topic_subscription.config_sns_subscription_west1.protocol}",
                  "owner" , "${data.aws_caller_identity.creds.account_id}",
                )}",
                "${aws_sns_topic_subscription.config_sns_subscription_west2.arn}" , "${map(
                  "endpoint" , "${aws_sns_topic_subscription.config_sns_subscription_west2.endpoint}",
                  "protocol" , "${aws_sns_topic_subscription.config_sns_subscription_west2.protocol}",
                  "owner" , "${data.aws_caller_identity.creds.account_id}",
                )}",
                "${aws_sns_topic_subscription.metric_sns_subscription.arn}" , "${map(
                  "endpoint" , "${aws_sns_topic_subscription.metric_sns_subscription.endpoint}",
                  "protocol" , "${aws_sns_topic_subscription.metric_sns_subscription.protocol}",
                  "owner" , "${data.aws_caller_identity.creds.account_id}",
                )}",
              )

        }"
}

output "aws_actions_performing_instance_ids" {
  value = [
    "${aws_instance.aws_support_access_instance.id}",
  ]
}

output "iam_manager_user_name" {
  value = "${aws_iam_user.iam_manager_user.name}"
}

output "iam_manager_role_name" {
  value = "${aws_iam_role.iam_manager_role.name}"
}

output "iam_manager_policy_name" {
  value = "${aws_iam_policy.iam_manager_policy.name}"
}

output "iam_master_user_name" {
  value = "${aws_iam_user.iam_master_user.name}"
}

output "iam_master_role_name" {
  value = "${aws_iam_role.iam_master_role.name}"
}

output "iam_master_policy_name" {
  value = "${aws_iam_policy.iam_master_policy.name}"
}
