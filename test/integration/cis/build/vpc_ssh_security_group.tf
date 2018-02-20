resource "aws_security_group" "ssh" {
  name   = "ssh"
  vpc_id = "${aws_default_vpc.default.id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "${var.ssh_security_group_cidr}",
    ]
  }
}
