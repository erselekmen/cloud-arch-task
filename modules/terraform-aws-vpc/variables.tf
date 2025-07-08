variable "create_vpc" {
  description = "Whether to create a new VPC"
  type        = bool
  default     = true
}

variable "create_igw" {
  description = "Whether to create an Internet Gateway"
  type        = bool
  default     = true
}

variable "cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

variable "map_public_ip_on_launch" {
  description = "Whether to auto-assign public IPs in public subnets"
  type        = bool
  default     = true
}

variable "assign_ipv6_address_on_creation" {
  description = "Whether to assign IPv6 addresses on subnet creation"
  type        = bool
  default     = false
}

variable "name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "public_subnet_suffix" {
  description = "Suffix to append to public subnet names"
  type        = string
  default     = "public"
}

variable "tags" {
  description = "Global tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

variable "igw_tags" {
  description = "Tags for the Internet Gateway"
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "Tags for public subnets"
  type        = map(string)
  default     = {}
}

variable "public_route_table_tags" {
  description = "Tags for the public route table"
  type        = map(string)
  default     = {}
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}
