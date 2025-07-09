variable "name" {
  type = string
  default = ""
  description = "Name of the secret"
}

variable "description" {
  type = string
  default = ""
  description = "Description of the secret"
}

variable "length" {
  type = number
  default = 16
  description = "Length of the secret"
}

variable "create_secret_value" {
  type = bool
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags"
}

variable "special_chars" {
  type = bool
  default = false
}