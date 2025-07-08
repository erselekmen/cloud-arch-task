#############################
# Locals (only what we need)
#############################
locals {
  vpc_id = element(concat(aws_vpc.this.*.id, [""]), 0)
}

########
# VPC
########
resource "aws_vpc" "this" {
  count = var.create_vpc ? 1 : 0

  cidr_block           = var.cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    { Name = var.name },
    var.tags,
    var.vpc_tags,
  )
}

