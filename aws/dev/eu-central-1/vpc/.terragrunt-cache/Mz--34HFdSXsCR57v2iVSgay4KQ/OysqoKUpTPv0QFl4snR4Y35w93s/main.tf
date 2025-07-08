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

#######################
# Internet Gateway
#######################
resource "aws_internet_gateway" "this" {
  count  = var.create_vpc && var.create_igw && length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = local.vpc_id

  tags = merge(
    { Name = var.name },
    var.tags,
    var.igw_tags,
  )
}

####################
# Public Subnet(s)
####################
resource "aws_subnet" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  vpc_id                    = local.vpc_id
  cidr_block                = var.public_subnets[count.index]
  availability_zone         = element(var.azs, count.index)
  map_public_ip_on_launch   = var.map_public_ip_on_launch
  assign_ipv6_address_on_creation = var.assign_ipv6_address_on_creation

  tags = merge(
    { Name = format("%s-${var.public_subnet_suffix}-%s", var.name, element(var.azs, count.index)) },
    var.tags,
    var.public_subnet_tags,
  )
}


#############################
# Public Route Table + Route
#############################
resource "aws_route_table" "public" {
  count  = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = local.vpc_id

  tags = merge(
    { Name = "${var.name}-${var.public_subnet_suffix}" },
    var.tags,
    var.public_route_table_tags,
  )
}

resource "aws_route" "public_internet_gateway" {
  count                   = var.create_vpc && var.create_igw && length(var.public_subnets) > 0 ? 1 : 0
  route_table_id          = aws_route_table.public[0].id
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.this[0].id
}

#####################################
# Subnet  Route‑table Association
#####################################
resource "aws_route_table_association" "public" {
  count          = var.create_vpc && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id
}
