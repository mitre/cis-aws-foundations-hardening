#=================================================================#
#                         Default VPC
#=================================================================#

resource "aws_default_vpc" "default" {
  tags {
    Name = "default"
  }
}

#=================================================================#
#                    Default Security Group
#=================================================================#

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_default_vpc.default.id}"
}

#=================================================================#
#                  Flow Logs for Default VPC
#=================================================================#

resource "aws_flow_log" "vpc_flow_log" {
  log_group_name = "${aws_cloudwatch_log_group.vpc_flow_log_group.name}"
  iam_role_arn   = "${aws_iam_role.vpc_flow_log_role.arn}"
  vpc_id         = "${aws_default_vpc.default.id}"
  traffic_type   = "REJECT"
}

resource "aws_cloudwatch_log_group" "vpc_flow_log_group" {
  name = "${var.prefix}-vpc-flow-log-group"
}

resource "aws_iam_role" "vpc_flow_log_role" {
  name = "${var.prefix}-vpc_flow_log_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "vpc_flow_log_role_policy" {
  name = "${var.prefix}-vpc_flow_log_role_policy"
  role = "${aws_iam_role.vpc_flow_log_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
