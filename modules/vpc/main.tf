data "aws_availability_zones" "available" {
}

locals {
  az_placement = slice(
    data.aws_availability_zones.available.names,
    0,
    var.az_placement,
  )

  public_subnets = [
    for num in local.az_placement :
    cidrsubnet(
      var.vpc_cidr,
      4,
      index(local.az_placement, num) % length(local.az_placement)
    )
  ]

  private_subnets = [
    for num in local.az_placement :
    cidrsubnet(
      var.vpc_cidr,
      4,
      index(local.az_placement, num) % length(local.az_placement) + length(local.az_placement)
    )
  ]

  database_subnets = [
    for num in local.az_placement :
    cidrsubnet(
      var.vpc_cidr,
      4,
      index(local.az_placement, num) % length(local.az_placement) + length(local.az_placement) * 2
    )
  ]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.68.0"

  create_vpc              = var.enable_vpc
  name                    = var.name
  azs                     = local.az_placement
  cidr                    = var.vpc_cidr
  enable_nat_gateway      = var.enable_nat_gateway
  single_nat_gateway      = var.single_nat_gateway
  one_nat_gateway_per_az  = var.one_nat_gateway_per_az
  private_subnets         = local.private_subnets
  public_subnets          = local.public_subnets
  map_public_ip_on_launch = var.map_public_ip_on_launch


  # DNS
  enable_dns_hostnames = var.vpc_enable_dns_hostnames
  enable_dns_support   = var.vpc_enable_dns_support

  # Enable public access to the database subnets
  database_subnets                       = var.enable_public_database ? local.database_subnets : []
  create_database_subnet_group           = var.enable_public_database
  create_database_subnet_route_table     = var.enable_public_database
  create_database_internet_gateway_route = var.enable_public_database

  # Endpoints
  enable_s3_endpoint             = var.enable_s3_endpoint
  enable_dynamodb_endpoint       = var.enable_dynamodb_endpoint
  enable_rds_endpoint            = var.enable_rds_endpoint
  enable_secretsmanager_endpoint = var.enable_secretsmanager_endpoint
  enable_ses_endpoint            = var.enable_ses_endpoint
  enable_ssm_endpoint            = var.enable_ssm_endpoint

  tags = merge(var.tags, var.kubernetes_tags)

  vpc_tags = {
    Name = "${var.name}-vpc"
  }

  # We have no idea if the vpc will host an eks
  # cluster but we put this here anyway
  public_subnet_tags = {
    "Tier"                   = "public"
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "Tier"                            = "private"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

