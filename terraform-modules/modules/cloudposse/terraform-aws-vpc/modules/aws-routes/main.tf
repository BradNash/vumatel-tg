locals {
  routing_product = setproduct(var.route_table_ids, var.cidr_blocks)
}

resource "aws_route" "default" {
  count                  = length(local.routing_product)
  route_table_id         = local.routing_product[count.index][0]
  destination_cidr_block = local.routing_product[count.index][1]
  transit_gateway_id     = var.transit_gateway_id
}
