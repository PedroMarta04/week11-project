# ==============================================================================
# RDS MODULE - variables.tf
# ==============================================================================

variable "name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "allowed_security_group_ids" {
  description = "Security group IDs allowed to connect to the DB"
  type        = list(string)
  default     = []
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to connect to the DB"
  type        = list(string)
  default     = []
}

variable "engine" {
  description = "Database engine"
  type        = string
  default     = "mysql"

  validation {
    condition     = contains(["mysql", "postgres", "mariadb"], var.engine)
    error_message = "engine must be one of: mysql, postgres, mariadb."
  }
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20

  validation {
    condition     = var.allocated_storage >= 20 && var.allocated_storage <= 1000
    error_message = "allocated_storage must be between 20 and 1000 GB."
  }
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 3306
}

variable "db_name" {
  description = "Name of the initial database"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Master username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Master password"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_password) >= 8
    error_message = "db_password must be at least 8 characters long."
  }
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on destroy (set false for production)"
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "Days to retain automated backups (0 disables backups)"
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Prevent accidental deletion"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
