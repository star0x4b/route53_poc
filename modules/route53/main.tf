variable name {}
variable zone_id {}
variable region {}
variable type {}
variable records {
  type = "list"
}

provider "aws" {
  region = "${var.region}"
}

#resource "aws_route53_zone" "geobalanced" {
#  name = "${var.zone}"
#}

resource "aws_route53_record" "geobalanced_core" {
  zone_id = "${var.zone_id}"
  name    = "web"
  type    = "${var.type}"
  ttl     = "30"

  latency_routing_policy {
    region = "${var.region}"
  }

  set_identifier = "${var.region}"
  records        = ["${var.records}"]
}
