# ==============================================================================
# EC2 MODULE - outputs.tf
# ==============================================================================

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.this.id
}

output "instance_arn" {
  description = "EC2 instance ARN"
  value       = aws_instance.this.arn
}

output "public_ip" {
  description = "Public IP address of the instance"
  value       = aws_instance.this.public_ip
}

output "private_ip" {
  description = "Private IP address of the instance"
  value       = aws_instance.this.private_ip
}

output "public_dns" {
  description = "Public DNS name of the instance"
  value       = aws_instance.this.public_dns
}

output "private_dns" {
  description = "Private DNS name of the instance"
  value       = aws_instance.this.private_dns
}

output "security_group_id" {
  description = "Security group ID attached to the instance"
  value       = aws_security_group.this.id
}

output "ami_id" {
  description = "AMI ID used to launch the instance"
  value       = aws_instance.this.ami
}

output "ssh_connection" {
  description = "SSH connection string (if public key was provided)"
  value       = var.public_key != "" ? "ssh -i <your-key.pem> ec2-user@${aws_instance.this.public_ip}" : "No key pair configured"
}
