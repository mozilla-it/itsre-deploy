provider "aws" {
  version = "~> 1"
  region  = "${var.region}"
}

locals {
  vpc_tags = "${merge(map("Region", "${var.region}", "Environment", "core"), var.default_tags)}"
}

module "users" {
  source                = "./modules/users"
  create_users          = "${lookup(var.features, "users")}"
  users                 = "${var.users}"
  delegated_account_ids = "${var.delegated_account_ids}"
}

module "infosec" {
  source  = "./modules/infosec"
  enabled = "${lookup(var.features, "infosec")}"

  cloudtrail_bucket    = "${lookup(var.infosec, "bucket")}"
  cloudtrail_sns_topic = "${lookup(var.infosec, "sns_topic")}"
}

module "dns" {
  source       = "./modules/dns"
  enabled      = "${lookup(var.features, "dns")}"
  account_name = "${var.account_name}"
}

module "vpc" {
  source                    = "./modules/vpc"
  region                    = "${var.region}"
  enable_vpc                = "${lookup(var.features, "vpc")}"
  name                      = "${lookup(var.vpc, "name")}"
  vpc_cidr                  = "${lookup(var.vpc, "vpc_cidr")}"
  az_placement              = "${lookup(var.vpc, "az_placement")}"
  enable_nat_gateway        = "${lookup(var.vpc, "enable_nat_gateway")}"
  enable_single_nat_gateway = "${lookup(var.vpc, "enable_single_nat_gateway")}"
  tags                      = "${local.vpc_tags}"
}
