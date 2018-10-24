variable "region" {
  default = "us-west-1"
}
variable "availability_zones" {
  # No spaces allowed between az names!
  default = {
#    ap-northeast-1 = ["ap-northeast-1a","ap-northeast-1b","ap-northeast-1c"]
#    us-west-1      = ["us-west-1a","us-west-1b","us-west-1c"]
    ap-northeast-1 = "ap-northeast-1a"
    us-west-1      = "us-west-1a"

  }
}
variable "key_name" {
  default = "admin"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "zone_id" {
  default = "Z3A3VBI1487NFR"
}

