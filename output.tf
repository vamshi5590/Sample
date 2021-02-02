output "vpc_id" {
  description = "the ID of the vpc"
  value  = "${aws_vpc.main.id}"
}
