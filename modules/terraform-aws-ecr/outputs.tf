output "arn" {
  description = "Full ARN of the repository."
  value       = aws_ecr_repository.this.arn
}

output "repository_url" {
  description = "The URL of the repository."
  value       = aws_ecr_repository.this.repository_url
}

output "login_url" {
  description = "The base URL of the ECR registry (without repository name)."
  value       = join("/", slice(split("/", aws_ecr_repository.this.repository_url), 0, 1))
}
