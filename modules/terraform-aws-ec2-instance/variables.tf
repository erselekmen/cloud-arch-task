variable "create" {
  description = "Whether to create an instance"
  type        = bool
  default     = true
}

variable "create_spot_instance" {
  description = "Whether to create a spot instance instead of on-demand"
  type        = bool
  default     = false
}

variable "allocate_eip" {
  description = "Whether to allocate and associate an Elastic IP"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name to be used on the EC2 instance"
  type        = string
  default     = ""
}

variable "instance_count" {
  description = "Number of EC2 instances to launch"
  type        = number
  default     = 1
}

variable "ami" {
  description = "AMI ID to use for the instance. Must be provided externally (e.g. from Terragrunt)"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "The instance type to use for the EC2 instance"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key pair name to associate with the instance"
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "Name of the IAM instance profile to attach"
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data script to pass to the instance"
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "Base64 encoded user data (alternative to user_data)"
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
  default     = null
}

variable "subnet_id" {
  description = "The subnet ID in which to launch the instance"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "List of subnet IDs for multi-AZ instance distribution"
  type        = list(string)
  default     = []
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate with the instance"
  type        = list(string)
  default     = null
}

variable "private_ip" {
  description = "Private IP address to assign to the instance"
  type        = string
  default     = null
}

variable "monitoring" {
  description = "Enable detailed CloudWatch monitoring"
  type        = bool
  default     = false
}

variable "root_block_device" {
  description = "Configuration for the root block device"
  type        = list(any)
  default     = []
}

variable "metadata_options" {
  description = "Configure EC2 instance metadata options"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to the instance"
  type        = map(string)
  default     = {}
}

variable "enable_volume_tags" {
  description = "Whether to enable volume-specific tags"
  type        = bool
  default     = true
}

variable "volume_tags" {
  description = "Tags to apply to attached volumes"
  type        = map(string)
  default     = {}
}
