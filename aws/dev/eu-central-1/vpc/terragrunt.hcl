include {
  path = find_in_parent_folders("root.hcl")
}

locals {
  root_dir            = dirname(find_in_parent_folders("root.hcl"))
  modules_dir         = get_repo_root()
  common_vars         = yamldecode(file(find_in_parent_folders("common_vars.yaml")))

  name                = "vpc"
  azs                 = ["eu-central-1a"]
  cidr                = "10.102.0.0/16"
  public_subnets      = ["10.102.1.0/24"]
  private_subnets     = ["10.102.11.0/24"]
}

terraform {
  source = "${local.modules_dir}/modules/terraform-aws-vpc"
}

inputs = {
  name = "${local.common_vars.namespace}-${local.common_vars.environment}-${local.name}"
  cidr = local.cidr
  azs  = local.azs

  public_subnets      = local.public_subnets
  private_subnets     = local.private_subnets

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_vpn_gateway   = true

  tags = local.common_vars.tags
}
