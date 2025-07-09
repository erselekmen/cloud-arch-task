include {
  path = find_in_parent_folders("root.hcl")
}

locals {
  root_dir    = dirname(find_in_parent_folders("root.hcl"))
  modules_dir = get_repo_root()
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  name        = "webapp-role"
}

terraform {
  source = "${local.modules_dir}/modules/terraform-aws-iam-roles"
}

inputs = {
  trusted_role_services = ["ec2.amazonaws.com"]
  role_name             = "${local.name}-${local.common_vars.environment}-${local.name}"

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]

  role_requires_mfa       = false
  create_role             = true
  create_instance_profile = true

  tags = local.common_vars.tags
}
