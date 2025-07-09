resource "random_password" "this" {
  count   = var.create_secret_value ? 1 : 0
  length  = var.length
  special = var.special_chars
}

resource "aws_secretsmanager_secret" "this" {
  name        = var.name
  description = var.description

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "this" {
  count         = var.create_secret_value ? 1 : 0
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = random_password.this[0].result
}

