provider "aws" {
  version = "~> 1"
  region  = "${var.region}"
}


# NOTE: modules don't accept count.index so i have no choice but to do this
module "subnets" {
  source   = "./subnets"
  vpc_cidr = "${var.vpc_cidr}"
  newbits  = "${var.newbits}"
  azs      = "${var.availability_zones}"
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.46.0"

  create_vpc             = "${var.enable_vpc}"
  name                   = "${var.name}"
  azs                    = "${var.availability_zones}"
  cidr                   = "${var.vpc_cidr}"
  enable_nat_gateway     = "${var.enable_nat_gateway}"
  single_nat_gateway     = "${var.single_nat_gateway}"
  one_nat_gateway_per_az = "${var.one_nat_gateway_per_az}"
  private_subnets        = "${module.subnets.private_subnets}"
  public_subnets         = "${module.subnets.public_subnets}"

  tags = "${var.tags}"

  vpc_tags = {
    Name = "${var.name}-vpc"
  }
}
