output "instance_id" {
  value = "${aws_instance.webserver.id}"
}

output "lb_arn" {
  value = "${aws_lb.core.arn}"
}

output "lb_dns" {
  value = "${aws_lb.core.dns_name}"
}
