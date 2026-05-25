# ==============================================================================
# ROOT - outputs.tf
# ==============================================================================

# --- Network (custom module) ---
output "vpc_id" {
  description = "VPC ID (custom module)"
  value       = module.network.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = module.network.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.network.private_subnet_ids
}

output "igw_id" {
  description = "Internet Gateway ID"
  value       = module.network.igw_id
}

# --- Compute ---
output "instance_id" {
  description = "EC2 instance ID"
  value       = module.compute.instance_id
}

output "instance_public_ip" {
  description = "EC2 public IP"
  value       = module.compute.public_ip
}

output "instance_public_dns" {
  description = "EC2 public DNS"
  value       = module.compute.public_dns
}

output "ssh_connection" {
  description = "SSH command to connect to the instance"
  value       = module.compute.ssh_connection
  sensitive   = true
}

output "web_url" {
  description = "HTTP URL for the web server"
  value       = "http://${module.compute.public_ip}"
}

# --- Database ---
output "db_endpoint" {
  description = "RDS connection endpoint"
  value       = module.database.db_endpoint
}

output "db_host" {
  description = "RDS hostname"
  value       = module.database.db_host
}

output "db_port" {
  description = "RDS port"
  value       = module.database.db_port
}

# --- Public Registry Module ---
output "public_module_vpc_id" {
  description = "VPC ID from the Terraform Registry module (Activity 5)"
  value       = module.vpc_public.vpc_id
}

output "public_module_public_subnet_ids" {
  description = "Public subnets from the Registry module"
  value       = module.vpc_public.public_subnets
}

# --- Activity 7 Dynamic SG ---
output "dynamic_sg_id" {
  description = "Dynamic security group ID (Activity 7)"
  value       = aws_security_group.dynamic_web.id
}

# --- Workspace info ---
output "workspace" {
  description = "Current Terraform workspace"
  value       = terraform.workspace
}
