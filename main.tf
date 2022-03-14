provider "aws" {
  region = var.region
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
  source               = "./modules/infosec"
  enabled              = local.features["infosec"]
  cloudtrail_bucket    = local.infosec["bucket"]
  cloudtrail_sns_topic = local.infosec["sns_topic"]
}

module "cloudhealth" {
  source                  = "./modules/cloudhealth"
  cloudhealth_role_name   = local.cloudhealth["role_name"]
  cloudhealth_external_id = local.cloudhealth["external_id"]
}

module "dns" {
  source       = "./modules/dns"
  enabled      = local.features["dns"]
  account_name = var.account_name
}

module "vpc" {
  source                         = "./modules/vpc"
  region                         = var.region
  enable_vpc                     = local.features["vpc"]
  name                           = local.vpc["name"]
  vpc_cidr                       = local.vpc["vpc_cidr"]
  az_placement                   = local.vpc["az_placement"]
  enable_nat_gateway             = local.vpc["enable_nat_gateway"]
  single_nat_gateway             = local.vpc["enable_single_nat_gateway"]
  one_nat_gateway_per_az         = local.vpc["enable_multiple_nat_gateway"]
  enable_dynamodb_endpoint       = local.vpc["enable_dynamodb_endpoint"]
  enable_s3_endpoint             = local.vpc["enable_s3_endpoint"]
  enable_rds_endpoint            = local.vpc["enable_rds_endpoint"]
  enable_secretsmanager_endpoint = local.vpc["enable_secretsmanager_endpoint"]
  enable_ses_endpoint            = local.vpc["enable_ses_endpoint"]
  enable_ssm_endpoint            = local.vpc["enable_ssm_endpoint"]
  enable_public_database         = local.vpc["enable_public_database"]
  tags                           = local.vpc_tags
}

