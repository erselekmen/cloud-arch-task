terraform {
  required_version = ">= 1.11.0, < 1.12.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.97.0"
    }
  }
}
