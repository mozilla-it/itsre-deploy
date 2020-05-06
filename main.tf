provider "aws" {
  version = "~> 2"
  region  = var.region
}

data "aws_caller_identity" "current" {
}

module "policies" {
  source  = "./modules/policies"
  enabled = local.features["policies"]
}

module "account" {
  source       = "./modules/account"
  account_name = var.account_name
  enabled      = local.features["account"]
}

module "users" {
  source                       = "./modules/users"
  create_users                 = local.features["users"]
  create_access_keys           = var.users["create_access_keys"]
  create_delegated_permissions = var.users["create_delegated_permissions"]
  write_access_files           = var.users["write_access_files"]
  users                        = var.admin_users
}

module "maws" {
  source             = "./modules/maws"
  enabled            = local.features["maws"]
  maws_roles_enabled = local.maws["roles"]
  maws_idp_enabled   = local.maws["idp"]
}

module "infosec" {
  source  = "./modules/infosec"
  enabled = local.features["infosec"]

  cloudtrail_bucket    = var.infosec["bucket"]
  cloudtrail_sns_topic = var.infosec["sns_topic"]
}

module "cloudhealth" {
  source = "./modules/cloudhealth"

  cloudhealth_role_name   = var.cloudhealth["role_name"]
  cloudhealth_external_id = var.cloudhealth["external_id"]
}

module "dns" {
  source       = "./modules/dns"
  enabled      = local.features["dns"]
  account_name = var.account_name
}

module "vpc" {
  source                   = "./modules/vpc"
  region                   = var.region
  enable_vpc               = local.features["vpc"]
  name                     = var.vpc["name"]
  vpc_cidr                 = var.vpc["vpc_cidr"]
  az_placement             = var.vpc["az_placement"]
  enable_nat_gateway       = var.vpc["enable_nat_gateway"]
  single_nat_gateway       = var.vpc["enable_single_nat_gateway"]
  one_nat_gateway_per_az   = var.vpc["enable_multiple_nat_gateway"]
  enable_dynamodb_endpoint = var.vpc["enable_dynamodb_endpoint"]
  enable_s3_endpoint       = var.vpc["enable_s3_endpoint"]
  tags                     = local.vpc_tags
}

