locals {
  public_azs             = local.public_enabled ? {for az in local.azs : az.az_name => az} : {}
  public_nat_gateway_azs = local.public_enabled && var.nat_gateway_enabled ? local.public_azs : {}
  ngw_name               = replace(module.this.id, "subnet", "natgw")
  public_rtb_name        = replace(module.this.id, "subnet", "rtb")
  public_nacl_name       = replace(module.this.id, "subnet", "nacl")
  public_eip_name        = replace(module.this.id, "subnet", "eip")
}

resource "aws_subnet" "public" {
  for_each = local.public_azs

  vpc_id            = var.vpc_id
  availability_zone = each.key
  cidr_block        = cidrsubnet(var.cidr_block, ceil(log(var.max_subnets, 2)), each.value.idx)

  tags = merge(
    module.this.tags,
    {
      Name = join(module.this.delimiter, [var.type, module.this.id_full, each.value.az_loc])
    },
    var.public_subnet_tags
  )
}

resource "aws_network_acl" "public" {
  count = local.public_enabled && var.public_network_acl_id == "" ? 1 : 0

  vpc_id     = var.vpc_id
  subnet_ids = values(aws_subnet.public)[*].id

  dynamic "egress" {
    for_each = var.public_network_acl_egress
    content {
      action          = lookup(egress.value, "action", null)
      cidr_block      = lookup(egress.value, "cidr_block", null)
      from_port       = lookup(egress.value, "from_port", null)
      icmp_code       = lookup(egress.value, "icmp_code", null)
      icmp_type       = lookup(egress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(egress.value, "ipv6_cidr_block", null)
      protocol        = lookup(egress.value, "protocol", null)
      rule_no         = lookup(egress.value, "rule_no", null)
      to_port         = lookup(egress.value, "to_port", null)
    }
  }
  dynamic "ingress" {
    for_each = var.public_network_acl_ingress
    content {
      action          = lookup(ingress.value, "action", null)
      cidr_block      = lookup(ingress.value, "cidr_block", null)
      from_port       = lookup(ingress.value, "from_port", null)
      icmp_code       = lookup(ingress.value, "icmp_code", null)
      icmp_type       = lookup(ingress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(ingress.value, "ipv6_cidr_block", null)
      protocol        = lookup(ingress.value, "protocol", null)
      rule_no         = lookup(ingress.value, "rule_no", null)
      to_port         = lookup(ingress.value, "to_port", null)
    }
  }
  tags = merge(
    module.this.tags,
    {
      Name = join(module.this.delimiter, [var.type, local.public_nacl_name])
    },
  )
  depends_on = [aws_subnet.public]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "public" {
  for_each = local.public_azs
  vpc_id   = var.vpc_id

  tags = merge(
    module.this.tags,
    {
      Name = join(module.this.delimiter, [var.type, local.public_rtb_name, each.value.az_loc])
    },
  )
}

resource "aws_route" "public" {
  for_each = local.public_azs

  route_table_id         = aws_route_table.public[each.key].id
  gateway_id             = var.igw_id
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.public]
}

resource "aws_route_table_association" "public" {
  for_each = local.public_azs

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.key].id
  depends_on     = [
    aws_subnet.public,
    aws_route_table.public,
  ]
}

resource "aws_eip" "public" {
  for_each = local.public_nat_gateway_azs
  domain   = "vpc"
  tags     = merge(
    module.this.tags,
    {
      Name = local.public_eip_name
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "public" {
  for_each = local.public_nat_gateway_azs

  allocation_id = aws_eip.public[each.key].id
  subnet_id     = aws_subnet.public[each.key].id
  depends_on    = [aws_subnet.public]

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.tags,
    {
      Name = join(module.this.delimiter, [local.ngw_name, each.value.az_loc])
    },
  )
}
