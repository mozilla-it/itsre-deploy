
locals {

  vpc_tags = merge(
    {
      "Region"      = var.region
      "Environment" = "core"
    },
    var.default_tags,
    var.kubernetes_tags,
  )

  features_defaults = {
    users    = false
    vpc      = false
    dns      = false
    maws     = true
    infosec  = true
    account  = true
    policies = true
  }
  features = merge(local.features_defaults, var.features)

  maws_defaults = {
    idp   = true
    roles = true
  }
  maws = merge(local.maws_defaults, var.maws)

}
