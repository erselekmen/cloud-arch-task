generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  provider "aws" {
    region  = "eu-central-1"
    profile = "ersel-local"
  }
  EOF
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket  = "cloud-task-infra"
    key     = "${path_relative_to_include()}/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
    profile = "ersel-local"
  }
}

# In order to delete terragrunt_cache files to resolve plugin errors on local
terraform {
  after_hook "terragrunt_cache_clean" {
    commands = ["apply", "destroy"]
    execute = [
      "bash", "-c",
      "rm -rf \"${get_terragrunt_dir()}/.terragrunt-cache\" && echo \".terragrunt-cache cleaned for ${get_terragrunt_dir()}\""
    ]
  }
}