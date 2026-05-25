# ==============================================================================
# Activity 10: Refactoring count → for_each
# File: for_each_refactor.tf  (reference/explanation file — not applied directly)
# ==============================================================================

# ------------------------------------------------------------------------------
# antes: using count
# se remover o server da lista, o terraform destroi e recria as subnets todas
# Resource addresses: aws_subnet.public_count[0], [1], [2]
# ------------------------------------------------------------------------------

# resource "aws_subnet" "public_count" {
#   count = length(var.public_subnet_cidrs)
#
#   vpc_id            = aws_vpc.this.id
#   cidr_block        = var.public_subnet_cidrs[count.index]
#   availability_zone = var.availability_zones[count.index]
#
#   tags = {
#     Name = "public-${count.index + 1}"
#   }
# }

# ------------------------------------------------------------------------------
# depois: using for_each
# beneficio: cada subnet tem o endereco ligado pela CIDR key. remover uma entry agora apenas destroi uma subnet especifica, as outras ficam lá
# Resource addresses: aws_subnet.public_foreach["10.0.1.0/24"], etc.
# ------------------------------------------------------------------------------

locals {
  # Build a map of cidr → az for for_each
  public_subnets_map = {
    for idx, cidr in var.public_subnet_cidrs :
    cidr => var.availability_zones[idx % length(var.availability_zones)]
  }
}

# resource "aws_subnet" "public_foreach" {
#   for_each = local.public_subnets_map
#
#   vpc_id            = aws_vpc.this.id
#   cidr_block        = each.key        # the CIDR
#   availability_zone = each.value      # the AZ
#
#   tags = {
#     Name = "public-${each.key}"
#   }
# }

# ------------------------------------------------------------------------------
# What changes in resource addressing
# ------------------------------------------------------------------------------
#
# count:    aws_subnet.public_count[0]            (integer index)
# for_each: aws_subnet.public_foreach["10.0.1.0/24"]  (stable string key)
#
# Why for_each is SAFER:
#
# Scenario: you have 3 subnets and remove the middle one.
#
# With count:
#   - Terraform sees [0],[1],[2] → now [0],[1]
#   - It DESTROYS [1] and RECREATES [2] (renumbered) → dangerous in production
#
# With for_each:
#   - Each subnet is keyed by CIDR. Removing "10.0.2.0/24" ONLY destroys that
#     one subnet. All others are untouched.
#   - Safe for long-term maintenance and production use.
# ------------------------------------------------------------------------------
