variable "name" {
  description = "name of ecr repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository"
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A mapping of tags to ecr repository"
  type        = map(string)
  default     = {}
}
