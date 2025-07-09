variable "name" {
  description = "Name for IAM role and instance profile"
  type        = string
  default     = "no"
}

variable "path" {
  description = "Path for the IAM role"
  type        = string
  default     = ""
}

variable "max_session_duration" {
  description = "Max STS session duration in seconds"
  type        = number
  default     = null
}

variable "force_detach_policies" {
  description = "Force detachment of any existing IAM policies"
  type        = bool
  default     = null
}

variable "permissions_boundary_arn" {
  description = "Optional IAM permissions boundary"
  type        = string
  default     = ""
}

variable "trusted_role_arns" {
  description = "Extra AWS principal ARNs trusted to assume this role"
  type        = list(string)
  default     = []
}

variable "policy_arns" {
  description = "List of IAM policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to the IAM resources"
  type        = map(string) 
  default     = {}
}
