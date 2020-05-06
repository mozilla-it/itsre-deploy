
module "idp" {
  source  = "./idp"
  enabled = var.enabled && var.maws_idp_enabled
}

module "roles" {
  source  = "./roles"
  enabled = var.enabled && var.maws_roles_enabled
}
