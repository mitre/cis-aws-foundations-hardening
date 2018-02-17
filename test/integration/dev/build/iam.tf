#======================================================#
#          Group with AWSSupportAccess Policy
#======================================================#

resource "aws_iam_group" "with_awssupportaccess" {
  name = "${var.prefix}-AWSSupportAccess-Group"
}

resource "aws_iam_policy_attachment" "attach_awssupportaccess" {
  name       = "${var.prefix}-attach-awssupportaccess"
  groups     = ["${aws_iam_group.with_awssupportaccess.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
}

output "aws_iam_group_with_awssupportaccess" {
  value = "${aws_iam_group.with_awssupportaccess.name}"
}

#======================================================#
#               IAM Master User
#======================================================#

resource "aws_iam_user" "iam_master_user" {
  name = "${var.prefix}-iam-master"
}

output "iam_master_user_name" {
  value = "${aws_iam_user.iam_master_user.name}"
}

#======================================================#
#               IAM Master Group
#======================================================#

resource "aws_iam_group" "iam_master_group" {
  name = "${var.prefix}-IAM-Master-Group"
}

resource "aws_iam_policy_attachment" "iam_master_role_assume_policy" {
  name       = "attach_iam_master_permissions_policy"
  groups     = ["${aws_iam_group.iam_master_group.name}"]
  policy_arn = "${aws_iam_policy.iam_master_role_assume_policy.arn}"

  depends_on = [
    "aws_iam_group.iam_master_group",
    "aws_iam_policy.iam_master_role_assume_policy",
  ]
}

resource "aws_iam_group_membership" "iam_master_group" {
  name = "${var.prefix}-IAM-Master-Group"

  users = [
    "${aws_iam_user.iam_master_user.name}",
  ]

  group = "${aws_iam_group.iam_master_group.name}"

  depends_on = [
    "aws_iam_group.iam_master_group",
  ]
}

output "iam_master_group_name" {
  value = "${aws_iam_group.iam_master_group.name}"
}

#======================================================#
#               IAM Master Role
#======================================================#

resource "aws_iam_role" "iam_master_role" {
  name = "${var.prefix}-iam-master-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_user.iam_master_user.arn}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "iam_master_role_attach" {
  role       = "${aws_iam_role.iam_master_role.name}"
  policy_arn = "${aws_iam_policy.iam_manager_policy.arn}"

  depends_on = [
    "aws_iam_role.iam_master_role",
    "aws_iam_policy.iam_manager_policy",
  ]
}

output "iam_master_role_name" {
  value = "${aws_iam_role.iam_master_role.name}"
}
