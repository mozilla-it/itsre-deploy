
module "idp" {
  source  = "./idp"
  enabled = var.enabled
}

module "roles" {
  source  = "./roles"
  enabled = var.enabled
}
