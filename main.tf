module "ec2_cluster-us-west-1" {
  source                 = "./modules/ec2-instance"
  name                   = "core-ec2"
  
  region		         = "us-west-1"
  key_name               = "${var.key_name}"
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
  key_name               = "${var.key_name}"
}

module "route53-ap-northeast-1" {
  source                 = "./modules/route53"
  name                   = "core-zone"
  zone_id                = "${var.zone_id}"
  region                 = "ap-northeast-1"
  type                   = "CNAME"
  records                = ["${module.ec2_cluster-ap-northeast-1.lb_dns}"]
}

