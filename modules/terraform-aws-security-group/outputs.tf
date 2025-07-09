output "this_security_group_id" {
  description = "The ID of the security group"
  value = concat(
    aws_security_group.this.*.id,
    aws_security_group.this_name_prefix.*.id,
    [""],
  )[0]
}

output "this_security_group_vpc_id" {
  description = "The VPC ID of the security group"
  value = concat(
    aws_security_group.this.*.vpc_id,
    aws_security_group.this_name_prefix.*.vpc_id,
    [""],
  )[0]
}