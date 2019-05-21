provider "aws" {
  version = "~> 1"
  region  = "${var.region}"
}

locals {
  vpc_tags = "${merge(map("Region", "${var.region}", "Environment", "core"), var.default_tags)}"
}

data "aws_caller_identity" "current" {}

module "account" {
  source       = "./modules/account"
  account_name = "${var.account_name}"
  enabled      = "${lookup(var.features, "account")}"
}

module "users" {
  source                       = "./modules/users"
  create_users                 = "${lookup(var.features, "users")}"
  create_access_keys           = "${lookup(var.users, "create_access_keys")}"
  create_delegated_permissions = "${lookup(var.users, "create_delegated_permissions")}"
  write_access_files           = "${lookup(var.users, "write_access_files")}"
  users                        = "${var.admin_users}"
  delegated_account_ids        = "${var.delegated_account_ids}"
}

module "infosec" {
  source  = "./modules/infosec"
  enabled = "${lookup(var.features, "infosec")}"

  cloudtrail_bucket    = "${lookup(var.infosec, "bucket")}"
  cloudtrail_sns_topic = "${lookup(var.infosec, "sns_topic")}"
}

module "cloudhealth" {
  source = "./modules/cloudhealth"

  cloudhealth_role_name   = "${lookup(var.cloudhealth, "role_name")}"
  cloudhealth_external_id = "${lookup(var.cloudhealth, "external_id")}"
}

module "dns" {
  source       = "./modules/dns"
  enabled      = "${lookup(var.features, "dns")}"
  account_name = "${var.account_name}"
}

module "vpc" {
  source                   = "./modules/vpc"
  region                   = "${var.region}"
  enable_vpc               = "${lookup(var.features, "vpc")}"
  name                     = "${lookup(var.vpc, "name")}"
  vpc_cidr                 = "${lookup(var.vpc, "vpc_cidr")}"
  az_placement             = "${lookup(var.vpc, "az_placement")}"
  enable_nat_gateway       = "${lookup(var.vpc, "enable_nat_gateway")}"
  single_nat_gateway       = "${lookup(var.vpc, "enable_single_nat_gateway")}"
  one_nat_gateway_per_az   = "${lookup(var.vpc, "enable_multiple_nat_gateway")}"
  enable_dynamodb_endpoint = "${lookup(var.vpc, "enable_dynamodb_endpoint")}"
  enable_s3_endpoint       = "${lookup(var.vpc, "enable_s3_endpoint")}"
  tags                     = "${local.vpc_tags}"
}
