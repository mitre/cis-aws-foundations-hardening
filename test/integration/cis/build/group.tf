resource "aws_iam_group" "with_awssupportaccess" {
  name = "${var.prefix}.with_awssupportaccess"
}

output "aws_iam_group_with_awssupportaccess" {
  value = "${aws_iam_group.with_awssupportaccess.name}"
}

resource "aws_iam_policy_attachment" "attach-awssupportaccess" {
  name       = "attach-awssupportaccess"
  groups     = ["${aws_iam_group.with_awssupportaccess.name}"]
  policy_arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
}
