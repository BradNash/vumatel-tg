/*
* # AWS VPC
*This module creates a CIS WAF based VPC with support for Transit Gateways, NAT Gateways, Private Hosted Zones,
*multiple subnets (Public, Private, Isolated, TGW), and automatic subnet division for multi-AZ setups.
*
*If `public_nat_gateway_enabled` variable is set to `true`, the module will provision NAT Gateways across all provided
*Availability Zones within the Public Subnets.
*
*If `create_tgw_attachment` variable is set to `true`, the module will provision a Transit Gateway Resource attachment.
*In this case `transit_gateway_id` becomes mandatory and needs to be given the id value of the pre-existing Transit Gateway.
*
*If `private_zone_name` variable is given a value, the module will provision a Private Hosted Zone for the VPC.
*/

locals {
  default_network_acl = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      icmp_code  = 0
      icmp_type  = 0
    },
  ]

  base_isolated_acls = [
    {
      "action" : "allow",
      "cidr_block" : var.isolated_subnets_cidr_block,
      "from_port" : 0,
      "protocol" : "-1",
      "rule_no" : 10,
      "to_port" : 0
    },
    {
      "action" : "allow",
      "cidr_block" : var.private_subnets_cidr_block,
      "from_port" : 0,
      "protocol" : "-1",
      "rule_no" : 20,
      "to_port" : 0
    }
  ]
  isolated_acls = length(var.semi_isolated_routed_subnets) > 0 ? (
    concat(local.base_isolated_acls, (
      [for idx, cidr in var.semi_isolated_routed_subnets :
        {
          "action" : "allow",
          "cidr_block" : cidr,
          "from_port" : 0,
          "protocol" : "-1",
          "rule_no" : (20 + (10 * (idx + 1))),
          "to_port" : 0
      }])
  )) : local.base_isolated_acls
}

#tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
module "vpc_base" {
  source                           = "cloudposse/vpc/aws"
  version                          = "2.0.0"
  name                             = module.this.id_full
  ipv4_primary_cidr_block          = var.vpc_cidr_block
  assign_generated_ipv6_cidr_block = false
  internet_gateway_enabled         = false
  default_network_acl_deny_all     = var.default_network_acl_deny_all
  default_security_group_deny_all  = var.default_security_group_deny_all
  default_route_table_no_routes    = var.default_route_table_no_routes
  context                          = module.this.context
  tags = merge(
    module.this.tags,
    {
      Name = module.this.id_full
    }
  )
}

resource "aws_internet_gateway" "default" {
  count  = var.internet_gateway_enabled ? 1 : 0
  vpc_id = module.vpc_base.vpc_id
  tags = merge(
    module.this.tags,
    {
      Name = replace(module.this.id_full, module.this.name, "igw")
    }
  )
}

module "public_subnets" {
  count                      = var.public_subnets_cidr_block == "" ? 0 : 1
  source                     = "./modules/aws-multi-az-subnets"
  name                       = "subnet"
  max_subnets                = length(var.subnet_azs)
  availability_zones         = var.subnet_azs
  vpc_id                     = module.vpc_base.vpc_id
  cidr_block                 = var.public_subnets_cidr_block
  type                       = "public"
  igw_id                     = one(aws_internet_gateway.default[*].id)
  nat_gateway_enabled        = var.public_nat_gateway_enabled
  public_network_acl_ingress = length(var.public_subnets_network_acl_ingress) > 0 ? var.public_subnets_network_acl_ingress : local.default_network_acl
  public_network_acl_egress  = length(var.public_subnets_network_acl_egress) > 0 ? var.public_subnets_network_acl_egress : local.default_network_acl
  public_subnet_tags         = var.public_subnet_tags
  private_subnet_tags        = var.private_subnet_tags
  context = merge(
    module.this.context,
    {
      name       = "subnet",
      attributes = concat(module.this.attributes, ["public"])
    }
  )
  depends_on = [
    module.vpc_base,
    aws_internet_gateway.default
  ]
}

module "tgw_subnets" {
  count                       = var.tgw_subnets_cidr_block == "" ? 0 : 1
  name                        = "subnet"
  source                      = "./modules/aws-multi-az-subnets"
  max_subnets                 = length(var.subnet_azs)
  availability_zones          = var.subnet_azs
  vpc_id                      = module.vpc_base.vpc_id
  cidr_block                  = var.tgw_subnets_cidr_block
  type                        = "private"
  nat_gateway_enabled         = "false"
  az_ngw_ids                  = var.public_nat_gateway_enabled ? one(module.public_subnets[*].az_ngw_ids) : {}
  private_network_acl_ingress = length(var.tgw_subnets_network_acl_ingress) > 0 ? var.tgw_subnets_network_acl_ingress : local.default_network_acl
  private_network_acl_egress  = length(var.tgw_subnets_network_acl_egress) > 0 ? var.tgw_subnets_network_acl_egress : local.default_network_acl

  context = merge(
    module.this.context,
    {
      name       = "subnet",
      attributes = concat(module.this.attributes, ["tgw"])
    }
  )

  depends_on = [
    module.vpc_base
  ]
}

module "private_subnets" {
  count                       = var.private_subnets_cidr_block == "" ? 0 : 1
  source                      = "./modules/aws-multi-az-subnets"
  name                        = "subnet"
  max_subnets                 = length(var.subnet_azs)
  availability_zones          = var.subnet_azs
  vpc_id                      = module.vpc_base.vpc_id
  cidr_block                  = var.private_subnets_cidr_block
  type                        = "private"
  nat_gateway_enabled         = "false"
  az_ngw_ids                  = var.public_nat_gateway_enabled ? one(module.public_subnets[*].az_ngw_ids) : {}
  private_network_acl_ingress = length(var.private_subnets_network_acl_ingress) > 0 ? var.private_subnets_network_acl_ingress : local.default_network_acl
  private_network_acl_egress  = length(var.private_subnets_network_acl_egress) > 0 ? var.private_subnets_network_acl_egress : local.default_network_acl
  private_subnet_tags         = var.private_subnet_tags
  public_subnet_tags          = var.public_subnet_tags

  context = merge(
    module.this.context,
    {
      name       = "subnet",
      attributes = concat(module.this.attributes, ["private"])
    }
  )
  depends_on = [
    module.vpc_base,
    module.public_subnets
  ]
}

resource "aws_route" "default" {
  for_each               = var.create_tgw_attachment && length(module.private_subnets) > 0 ? module.private_subnets[0].az_subnet_map : {}
  route_table_id         = each.value["route_table_id"]
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = var.transit_gateway_id
}

module "semi_isolated_routes" {
  count              = (length(var.semi_isolated_routed_subnets) > 0 && var.create_tgw_attachment && length(module.private_subnets) > 0 ? 1 : 0)
  source             = "./modules/aws-routes"
  route_table_ids    = [for item in module.isolated_subnets[0].az_subnet_map : item.route_table_id]
  cidr_blocks        = var.semi_isolated_routed_subnets
  transit_gateway_id = var.transit_gateway_id
}

module "isolated_subnets" {
  count                       = var.isolated_subnets_cidr_block == "" ? 0 : 1
  source                      = "./modules/aws-multi-az-subnets"
  name                        = "subnet"
  label_value_case            = "lower"
  max_subnets                 = length(var.subnet_azs)
  availability_zones          = var.subnet_azs
  vpc_id                      = module.vpc_base.vpc_id
  cidr_block                  = var.isolated_subnets_cidr_block
  type                        = "isolated"
  nat_gateway_enabled         = "false"
  private_network_acl_ingress = local.isolated_acls
  private_network_acl_egress  = local.isolated_acls

  context = merge(
    module.this.context,
    {
      name       = "subnet",
      attributes = concat(module.this.attributes, ["isolated"])
    }
  )

  depends_on = [
    module.vpc_base
  ]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "default" {
  count                  = var.create_tgw_attachment ? 1 : 0
  transit_gateway_id     = var.transit_gateway_id
  vpc_id                 = module.vpc_base.vpc_id
  subnet_ids             = values(module.tgw_subnets[0].az_subnet_ids)
  appliance_mode_support = var.tgw_vpc_attachment_appliance_mode_support
  dns_support            = var.tgw_vpc_attachment_dns_support
  ipv6_support           = var.tgw_vpc_attachment_ipv6_support

  transit_gateway_default_route_table_association = var.is_external_account ? null : false
  transit_gateway_default_route_table_propagation = var.is_external_account ? null : false

  tags = merge(
    module.this.tags,
    {
      Name = replace(module.this.id_full, "vpc", "tgwattachment")
    }
  )

  depends_on = [
    module.vpc_base,
    module.tgw_subnets
  ]
}

resource "aws_route53_zone" "PrivateZone" {
  count = var.private_zone_name == "" ? 0 : 1
  name  = var.private_zone_name
  tags = merge(
    module.this.tags,
    {
      Name = var.private_zone_name
    }
  )
  vpc {
    vpc_id = module.vpc_base.vpc_id
  }

  lifecycle {
    ignore_changes = [vpc]
  }

  depends_on = [
    module.vpc_base
  ]

}

resource "aws_route53_resolver_rule_association" "this" {
  for_each         = var.resolver_rule_ids
  resolver_rule_id = each.key
  vpc_id           = module.vpc_base.vpc_id
}