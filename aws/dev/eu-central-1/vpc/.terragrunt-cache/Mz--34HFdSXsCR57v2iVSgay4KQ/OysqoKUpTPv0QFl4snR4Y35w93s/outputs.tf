output "vpc_id" {
  value = local.vpc_id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}
