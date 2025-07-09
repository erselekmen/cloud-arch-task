###########################################
# Security Group
###########################################

locals {
  this_sg_id = concat(
    aws_security_group.this[*].id,
    aws_security_group.this_name_prefix[*].id,
    [""],
  )[0]
}

resource "aws_security_group" "this" {
  count                  = var.create && !var.use_name_prefix ? 1 : 0
  name                   = var.name
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

  tags = merge({ Name = var.name }, var.tags)
}

resource "aws_security_group" "this_name_prefix" {
  count                  = var.create && var.use_name_prefix ? 1 : 0
  name_prefix            = "${var.name}-"
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

  tags = merge({ Name = var.name }, var.tags)

  lifecycle {
    create_before_destroy = true
  }
}

##########################################
# Ingress Rules
##########################################

resource "aws_security_group_rule" "ingress_with_cidr_blocks" {
  count             = var.create ? length(var.ingress_with_cidr_blocks) : 0
  security_group_id = local.this_sg_id
  type              = "ingress"
  cidr_blocks       = split(",", lookup(var.ingress_with_cidr_blocks[count.index], "cidr_blocks", "0.0.0.0/0"))
  from_port         = tonumber(lookup(var.ingress_with_cidr_blocks[count.index], "from_port", 0))
  to_port           = tonumber(lookup(var.ingress_with_cidr_blocks[count.index], "to_port", 65535))
  protocol          = lookup(var.ingress_with_cidr_blocks[count.index], "protocol", "-1")
  description       = lookup(var.ingress_with_cidr_blocks[count.index], "description", "Ingress Rule")
}

##########################################
# Egress Rules 
##########################################

resource "aws_security_group_rule" "egress_with_cidr_blocks" {
  count             = var.create ? length(var.egress_with_cidr_blocks) : 0
  security_group_id = local.this_sg_id
  type              = "egress"
  cidr_blocks       = split(",", lookup(var.egress_with_cidr_blocks[count.index], "cidr_blocks", "0.0.0.0/0"))
  from_port         = tonumber(lookup(var.egress_with_cidr_blocks[count.index], "from_port", 0))
  to_port           = tonumber(lookup(var.egress_with_cidr_blocks[count.index], "to_port", 65535))
  protocol          = lookup(var.egress_with_cidr_blocks[count.index], "protocol", "-1")
  description       = lookup(var.egress_with_cidr_blocks[count.index], "description", "Egress Rule")
}
