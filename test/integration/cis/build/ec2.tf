#======================================================#
#                    EC2 Instances
#======================================================#

resource "aws_instance" "aws_support_access_instance" {
  ami                    = "${data.aws_ami.centos.id}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.ssh.id}"]
  iam_instance_profile   = "${aws_iam_instance_profile.aws_support_access_instance_profile.name}"
  key_name               = "${var.instance_key_name}"

  tags {
    Name = "${var.prefix}.aws_support_access_instance"
  }
}

#----------------- has_role property ------------------#

# Has a role
resource "aws_iam_role" "aws_support_access_role" {
  name = "${var.prefix}.aws_support_access_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy" "AWSSupportAccess" {
  arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
}

resource "aws_iam_role_policy_attachment" "aws_support_access_role_attach" {
  role       = "${aws_iam_role.aws_support_access_role.name}"
  policy_arn = "${data.aws_iam_policy.AWSSupportAccess.arn}"

  depends_on = [
    "aws_iam_role.aws_support_access_role",
    "data.aws_iam_policy.AWSSupportAccess",
  ]
}

resource "aws_iam_instance_profile" "aws_support_access_instance_profile" {
  name = "${var.prefix}.aws_support_access_instance_profile"
  role = "${aws_iam_role.aws_support_access_role.name}"

  depends_on = [
    "aws_iam_role.aws_support_access_role",
  ]
}

#---------------------- image_id property --------------------------#

# Debian
data "aws_ami" "debian" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-jessie-amd64-hvm-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Centos
data "aws_ami" "centos" {
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
