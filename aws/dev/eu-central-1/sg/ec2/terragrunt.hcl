include {
  path = find_in_parent_folders("root.hcl")
}

locals {
  root_dir     = dirname(find_in_parent_folders("root.hcl"))
  modules_dir  = get_repo_root()
  common_vars  = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  source_ip    = "3.70.64.111/32"
}

terraform {
  source = "${local.modules_dir}/modules/terraform-aws-security-group"
}

inputs = {
  name        = "${local.common_vars.namespace}-${local.common_vars.environment}-sg"
  description = "Security group for EC2 with ingress from static IP and egress to internet"
  vpc_id      = dependency.vpc.outputs.vpc_id

  ingress_with_cidr_blocks = [
    {
      description = "Allow SSH from static IP"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = local.source_ip
    },
    {
      description = "Allow HTTP Requests from the static IP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = local.source_ip
    }
  ]

  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow all outbound connections"
    }
  ]

  tags = local.common_vars.tags
}

dependency "vpc" {
  config_path = "${local.root_dir}/vpc"
}
