output "iam_role_name" {
  description = "Name of the IAM role created"
  value       = aws_iam_role.this.name
}

output "iam_instance_profile_name" {
  description = "Name of the instance profile to attach to EC2"
  value       = aws_iam_instance_profile.this.name
}
