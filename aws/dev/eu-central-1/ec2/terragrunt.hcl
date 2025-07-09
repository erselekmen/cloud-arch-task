include {
  path = find_in_parent_folders("root.hcl")
}

locals {
  root_dir      = dirname(find_in_parent_folders("root.hcl"))
  modules_dir   = get_repo_root()
  common_vars   = yamldecode(file(find_in_parent_folders("common_vars.yaml")))

  name          = "cloud-task"
  ami           = "ami-02003f9f0fde924ea" # Latest Ubuntu Server 24.04 LTS
  instance_type = "t3.small"
  volume_size   = 500
  iops          = 8000
  throughput    = 375
  volume_type   = "gp3"
  encrypted     = true

  key_pair      = "ersel-ipercept"

  region            = local.common_vars.region
  account_id        = local.common_vars.account_id
  repo_url          = "${local.account_id}.dkr.ecr.${local.region}.amazonaws.com/${local.common_vars.namespace}/webapp"
  credential_helper = <<-EOF
    {
      "credHelpers": {
        "${local.repo_url}": "ecr-login"
      }
    }
  EOF
}

terraform {
  source = "${local.modules_dir}/modules/terraform-aws-ec2-instance"
}

inputs = {
  name                         = "${local.common_vars.namespace}-${local.common_vars.environment}-instance"
  ami                          = local.ami
  instance_type                = local.instance_type
  monitoring                   = true
  vpc_security_group_ids       = [dependency.sg_ec2.outputs.this_security_group_id]
  subnet_id                    = dependency.vpc.outputs.public_subnet_ids[0]
  associate_public_ip_address  = true

  iam_instance_profile         = dependency.iam_roles_ec2_webapp.outputs.iam_instance_profile_name

  root_block_device = [{
    volume_size = local.volume_size
    volume_type = local.volume_type
    encrypted   = local.encrypted
    iops        = local.iops
    throughput  = local.throughput
  }]

  key_name      = local.key_pair

  user_data     = <<-EOF
    #!/bin/bash

    apt-get update -y && apt-get install -y docker.io awscli curl

    # Install ECR credential helper
    ARCH=$(uname -m)
    curl -Lo /usr/local/bin/docker-credential-ecr-login \
         https://amazon-ecr-credential-helper-releases.s3.amazonaws.com/0.7.0/linux-$ARCH/docker-credential-ecr-login
    chmod +x /usr/local/bin/docker-credential-ecr-login

    useradd -m -s /bin/bash ipercept
    mkdir -p /home/ipercept/.ssh
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMBt89Sx7ukQX3b8O5U0yw7DRnkV0GQv1dC1vbrJEYKU" > /home/ipercept/.ssh/authorized_keys
    chown -R ipercept:ipercept /home/ipercept/.ssh
    chmod 700 /home/ipercept/.ssh
    chmod 600 /home/ipercept/.ssh/authorized_keys

    # Configure Docker credential helper for ECR
    mkdir -p /home/ipercept/.docker
    echo '${local.credential_helper}' > /home/ipercept/.docker/config.json
    chown -R ipercept:ipercept /home/ipercept/.docker

    # Run the container
    docker pull ${local.repo_url}:latest
    docker run -d --restart always -p 80:8000 --name web ${local.repo_url}:latest
  EOF
  EOF

  tags = local.common_vars.tags
}

dependency "vpc" {
  config_path = "${local.root_dir}/vpc"
}

dependency "sg_ec2" {
  config_path = "${local.root_dir}/sg/ec2"
}

dependency "iam_roles_ec2_webapp" {
  config_path = "${local.root_dir}/iam/roles/ec2/web"
}