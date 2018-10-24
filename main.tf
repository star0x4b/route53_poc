
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

module "ec2_cluster-us-west-1" {
  source                 = "./modules/ec2-instance"
  name                   = "core-ec2"
  
  region		 = "us-west-1"
  ami                    = "${data.aws_ami.amazon_linux.id}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${data.aws_security_group.default.id}"]
  subnet_ids             = ["${data.aws_subnet_ids.all.ids}"]
  vpc_id                 = "${data.aws_vpc.default.id}"
}

module "route53-us-west-1" {
  source                 = "./modules/route53"
  name                   = "core-zone"
  zone_id                = "${var.zone_id}"
  region                 = "us-west-1"
  type                   = "CNAME"
  records                = ["${module.ec2_cluster-us-west-1.lb_dns}"]
}

module "ec2_cluster-ap-northeast-1" {
  source                 = "./modules/ec2-instance"
  name                   = "core-ec2"

  region                 = "ap-northeast-1"
  ami                    = "${data.aws_ami.amazon_linux.id}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${data.aws_security_group.default.id}"]
  subnet_ids             = ["${data.aws_subnet_ids.all.ids}"]
  vpc_id                 = "${data.aws_vpc.default.id}"
}

module "route53-ap-northeast-1" {
  source                 = "./modules/route53"
  name                   = "core-zone"
  zone_id                = "${var.zone_id}"
  region                 = "ap-northeast-1"
  type                   = "CNAME"
  records                = ["${module.ec2_cluster-ap-northeast-1.lb_dns}"]
}

