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
