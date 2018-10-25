variable "name" {}
variable "key_name" {}
variable "region" {}

provider "aws" {
  region = "${var.region}"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default.id}"
}

data "aws_security_group" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
  name   = "default"
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}

resource "aws_instance" "webserver" {
  ami                         = "${data.aws_ami.amazon_linux.id}"
  instance_type               = "t2.micro"
  associate_public_ip_address = false
  subnet_id                   = "${element(data.aws_subnet_ids.all.ids, 0)}"
  vpc_security_group_ids      = ["${data.aws_security_group.default.id}"]
  key_name                    = "${var.key_name}"
}

resource "aws_lb" "core" {
  name               = "core"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["${data.aws_subnet_ids.all.ids}"]

  enable_deletion_protection = false
}

resource "aws_lb_listener" "core" {
  load_balancer_arn = "${aws_lb.core.arn}"
  port              = "22"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.core.arn}"
  }
}

resource "aws_lb_target_group" "core" {
  name     = "core"
  port     = 22
  protocol = "TCP"
  vpc_id   = "${data.aws_vpc.default.id}"
}

resource "aws_lb_target_group_attachment" "core" {
  target_group_arn = "${aws_lb_target_group.core.arn}"
  target_id        = "${aws_instance.webserver.id}"
  port             = 22
}
