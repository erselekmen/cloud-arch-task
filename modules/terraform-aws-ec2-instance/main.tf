resource "aws_eip" "this" {
  count = var.allocate_eip ? 1 : 0

  tags = merge({ Name = var.name }, var.tags)
}

##################################
# EC2 Instance (on‑demand)       #
##################################
resource "aws_instance" "this" {
  count = var.create && !var.create_spot_instance ? var.instance_count : 0

  ami               = var.ami            # passed in from terragrunt.hcl
  instance_type     = var.instance_type
  key_name          = var.key_name       # ipercept key
  user_data         = var.user_data
  user_data_base64  = var.user_data_base64
  monitoring        = var.monitoring
  hibernation       = var.hibernation
  iam_instance_profile = var.iam_instance_profile

  subnet_id              = length(var.subnet_ids) > 0 ? var.subnet_ids[count.index % length(var.subnet_ids)] : var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  associate_public_ip_address = var.associate_public_ip_address
  private_ip                  = var.private_ip

  #######################
  # Root volume options #
  #######################
  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      throughput            = lookup(root_block_device.value, "throughput", null)
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      tags                  = lookup(root_block_device.value, "tags", null)
    }
  }

  ##################################
  # Misc instance‑level attributes #
  ##################################
  ebs_optimized = var.ebs_optimized

  credit_specification {
    cpu_credits = var.cpu_credits
  }

  enclave_options { enabled = var.enclave_options_enabled }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  tags        = merge({ Name = var.instance_count > 1 ? "${var.name}-${format("%02d", count.index + 1)}" : var.name }, var.tags)
  volume_tags = var.enable_volume_tags ? merge({ Name = var.instance_count > 1 ? "${var.name}-${format("%02d", count.index + 1)}" : var.name }, var.volume_tags) : null
}

#################################
# Associate EIP with the instance
#################################
resource "aws_eip_association" "this" {
  count         = var.allocate_eip ? 1 : 0
  instance_id   = aws_instance.this[0].id
  allocation_id = aws_eip.this[0].id
}
