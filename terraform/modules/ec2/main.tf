# ==============================================================================
# EC2 MODULE - main.tf
# ==============================================================================

# ------------------------------------------------------------------------------
# Data: latest Amazon Linux 2023 AMI
# ------------------------------------------------------------------------------
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ------------------------------------------------------------------------------
# Security Group
# ------------------------------------------------------------------------------
resource "aws_security_group" "this" {
  name        = "${var.name}-sg"
  description = "Security group for ${var.name}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.allowed_cidr_blocks
      description = "Allow port ${ingress.value}"
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(var.tags, {
    Name = "${var.name}-sg"
  })
}

# ------------------------------------------------------------------------------
# Key Pair (optional — only created if public_key is provided)
# ------------------------------------------------------------------------------
resource "aws_key_pair" "this" {
  count = var.public_key != "" ? 1 : 0

  key_name   = "${var.name}-key"
  public_key = var.public_key

  tags = var.tags
}

# ------------------------------------------------------------------------------
# EC2 Instance
# ------------------------------------------------------------------------------
resource "aws_instance" "this" {
  ami                         = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.this.id]
  key_name                    = var.public_key != "" ? aws_key_pair.this[0].key_name : null
  associate_public_ip_address = var.associate_public_ip

  user_data = var.user_data != "" ? var.user_data : null

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  tags = merge(var.tags, {
    Name = "${var.name}-instance"
  })

  lifecycle {
    ignore_changes = [ami]
  }
}
