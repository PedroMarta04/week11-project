# ==============================================================================
# ROOT - variables.tf
# Activity 6: Variable validation and sensitive inputs
# ==============================================================================

variable "project_name" {
  description = "Project name prefix for all resources"
  type        = string
  default     = "week9"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# ------------------------------------------------------------------------------
# Network
# ------------------------------------------------------------------------------

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block (e.g. 10.0.0.0/16)."
  }
}

variable "availability_zones" {
  description = "Availability zones to deploy into"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "At least two availability zones must be specified."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "create_nat_gateway" {
  description = "Create a NAT Gateway for private subnets"
  type        = bool
  default     = false
}

# ------------------------------------------------------------------------------
# Compute
# ------------------------------------------------------------------------------

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"

  validation {
    condition     = contains(["t2.micro", "t3.micro"], var.instance_type)
    error_message = "instance_type must be a free-tier-eligible type: t2.micro or t3.micro."
  }
}

variable "allowed_ports" {
  description = "List of TCP ports to open (Activity 7: drives dynamic SG rules)"
  type        = list(number)
  default     = [22, 80, 443]

  validation {
    condition     = alltrue([for p in var.allowed_ports : p > 0 && p <= 65535])
    error_message = "All ports must be between 1 and 65535."
  }
}

variable "public_key" {
  description = "SSH public key for EC2 access (contents of ~/.ssh/id_rsa.pub)"
  type        = string
  default     = ""
  sensitive   = true
}

# ------------------------------------------------------------------------------
# Database — sensitive inputs (Activity 6)
# ------------------------------------------------------------------------------

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
  default     = "ChangeMe123!"

  validation {
    condition     = length(var.db_password) >= 8
    error_message = "db_password must be at least 8 characters."
  }
}

# ------------------------------------------------------------------------------
# Tags
# ------------------------------------------------------------------------------

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}
