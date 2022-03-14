
locals {

  cloudhealth_defaults = {
    role_name   = "cloud_health_role"
    external_id = "62f85b3d4efcbeb2b360ae857fec1e" # pragma: allowlist secret
  }
  cloudhealth = merge(local.cloudhealth_defaults, var.cloudhealth)

  infosec_defaults = {
    bucket    = "mozilla-cloudtrail-logs"
    sns_topic = "arn:aws:sns:us-west-2:088944123687:MozillaCloudTrailLogs"
  }
  infosec = merge(local.infosec_defaults, var.infosec)

  vpc_defaults = {
    name                           = "main-vpc"
    vpc_cidr                       = "172.16.0.0/16"
    az_placement                   = "3"
    enable_nat_gateway             = true
    enable_single_nat_gateway      = true
    enable_multiple_nat_gateway    = false
    enable_dynamodb_endpoint       = false
    enable_s3_endpoint             = false
    enable_rds_endpoint            = false
    enable_secretsmanager_endpoint = false
    enable_ses_endpoint            = false
    enable_ssm_endpoint            = false
    enable_public_database         = false
  }
  vpc = merge(local.vpc_defaults, var.vpc)

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
