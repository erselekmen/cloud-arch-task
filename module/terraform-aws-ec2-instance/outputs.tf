output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this[0].id
}

output "public_ip" {
  description = "Elastic or auto‑assigned public IP"
  value = coalesce(
    try(aws_eip.this[0].public_ip, null),
    aws_instance.this[0].public_ip,
  )
}

output "private_ip" {
  description = "Primary private IP"
  value       = aws_instance.this[0].private_ip
}

output "ami_id" {
  description = "AMI ID supplied from Terragrunt"
  value       = var.ami
}
