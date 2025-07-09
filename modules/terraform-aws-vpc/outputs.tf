output "vpc_id" {
  description = "The ID of the VPC"
  value = concat(
    aws_vpc.this.*.id,
    [""],
  )[0]
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value = concat(
    aws_vpc.this.*.cidr_block,
    [""],
  )[0]
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value = aws_subnet.public[*].id
}

output "public_subnet_cidr_blocks" {
  description = "List of public subnet CIDR blocks"
  value = aws_subnet.public[*].cidr_block
}
