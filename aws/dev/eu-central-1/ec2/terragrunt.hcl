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
    useradd -m -s /bin/bash ipercept
    mkdir -p /home/ipercept/.ssh
    echo "ssh-ed25519 your_pub_key_here" > /home/ipercept/.ssh/authorized_keys
    chown -R ipercept:ipercept /home/ipercept/.ssh
    chmod 700 /home/ipercept/.ssh
    chmod 600 /home/ipercept/.ssh/authorized_keys
  EOF

  tags = local.common_vars.tags
}

dependency "vpc" {
  config_path = "${local.root_dir}/vpc"
}

dependency "sg_ec2" {
  config_path = "${local.root_dir}/sg/ec2"
}
