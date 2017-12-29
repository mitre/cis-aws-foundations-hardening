output "public_dns" {
  value = "${aws_instance.example.public_dns}"
}

# add vpc_id so we can run the next kitchen run
