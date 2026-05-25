# ==============================================================================
# EC2 MODULE - variables.tf
# ==============================================================================

variable "name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the instance will be launched"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs (instance launches in the first one)"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"

  validation {
    condition     = contains(["t2.micro", "t3.micro"], var.instance_type)
    error_message = "instance_type must be a free-tier-eligible type: t2.micro or t3.micro."
  }
}

variable "ami_id" {
  description = "Custom AMI ID. If empty, latest Amazon Linux 2023 is used."
  type        = string
  default     = ""
}

variable "allowed_ports" {
  description = "List of TCP ports to open in the security group"
  type        = list(number)
  default     = [22, 80, 443]
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed for ingress rules"
  type        = list(string)
  default     = ["0.0.0.0/0"]

  validation {
    condition     = alltrue([for cidr in var.allowed_cidr_blocks : can(cidrhost(cidr, 0))])
    error_message = "All entries in allowed_cidr_blocks must be valid CIDR notation."
  }
}

variable "public_key" {
  description = "SSH public key material (e.g. contents of ~/.ssh/id_rsa.pub). Leave empty to skip key pair creation."
  type        = string
  default     = ""
  sensitive   = true
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP address"
  type        = bool
  default     = true
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 20

  validation {
    condition     = var.root_volume_size >= 8 && var.root_volume_size <= 100
    error_message = "root_volume_size must be between 8 and 100 GB."
  }
}

variable "user_data" {
  description = "User data script to run on instance launch"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
