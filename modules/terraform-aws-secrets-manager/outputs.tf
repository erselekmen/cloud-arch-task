output "arn" {
  description = "AWS SecretManager Secret ARN"
  value       = aws_secretsmanager_secret.this.arn
}

output "secret_value" {
  description = "Secret value"
  value       = var.create_secret_value ? random_password.this[0].result : null
  sensitive   = true
}

output "secret_id" {
  description = "The ID of the secret"
  value       = try(var.name, null)
}

