output "igw_id" {
  value = one(aws_internet_gateway.default[*].id)
}

output "vpc_cidr_block" {
  value = module.vpc_base.vpc_cidr_block
}

output "vpc_default_network_acl_id" {
  value = module.vpc_base.vpc_default_network_acl_id
}

output "vpc_default_route_table_id" {
  value = module.vpc_base.vpc_default_route_table_id
}

output "vpc_id" {
  value = module.vpc_base.vpc_id
}

output "transit_gateway_vpc_attachment_id" {
  value = one(aws_ec2_transit_gateway_vpc_attachment.default[*].id)
}

output "vpc_main_route_table_id" {
  value = module.vpc_base.vpc_main_route_table_id
}

output "vpc_default_security_group_id" {
  value = module.vpc_base.vpc_default_security_group_id
}

output "public_az_ngw_ids" {
  value = one(module.public_subnets[*].az_ngw_ids)
}

output "public_az_route_table_ids" {
  value = one(module.public_subnets[*].az_route_table_ids)
}

output "public_az_subnet_arns" {
  value = one(module.public_subnets[*].az_subnet_arns)
}

output "public_az_subnet_cidr_blocks" {
  value = one(module.public_subnets[*].az_subnet_cidr_blocks)
}

output "public_az_subnet_ids" {
  value = one(module.public_subnets[*].az_subnet_ids)
}

output "public_az_subnet_map" {
  value = one(module.public_subnets[*].az_subnet_map)
}

output "tgw_az_ngw_ids" {
  value = one(module.tgw_subnets[*].az_ngw_ids)
}

output "tgw_az_route_table_ids" {
  value = one(module.tgw_subnets[*].az_route_table_ids)
}

output "tgw_az_subnet_arns" {
  value = one(module.tgw_subnets[*].az_subnet_arns)
}

output "tgw_az_subnet_cidr_blocks" {
  value = one(module.tgw_subnets[*].az_subnet_cidr_blocks)
}

output "tgw_az_subnet_ids" {
  value = one(module.tgw_subnets[*].az_subnet_ids)
}

output "tgw_az_subnet_map" {
  value = one(module.tgw_subnets[*].az_subnet_map)
}

output "private_az_ngw_ids" {
  value = one(module.private_subnets[*].az_ngw_ids)
}

output "private_az_route_table_ids" {
  value = one(module.private_subnets[*].az_route_table_ids)
}

output "private_az_subnet_arns" {
  value = one(module.private_subnets[*].az_subnet_arns)
}

output "private_az_subnet_cidr_blocks" {
  value = one(module.private_subnets[*].az_subnet_cidr_blocks)
}

output "private_az_subnet_ids" {
  value = one(module.private_subnets[*].az_subnet_ids)
}

output "private_az_subnet_map" {
  value = one(module.private_subnets[*].az_subnet_map)
}

output "isolated_az_ngw_ids" {
  value = one(module.isolated_subnets[*].az_ngw_ids)
}

output "isolated_az_route_table_ids" {
  value = one(module.isolated_subnets[*].az_route_table_ids)
}

output "isolated_az_subnet_arns" {
  value = one(module.isolated_subnets[*].az_subnet_arns)
}

output "isolated_az_subnet_cidr_blocks" {
  value = one(module.isolated_subnets[*].az_subnet_cidr_blocks)
}

output "isolated_az_subnet_ids" {
  value = one(module.isolated_subnets[*].az_subnet_ids)
}

output "isolated_az_subnet_map" {
  value = one(module.isolated_subnets[*].az_subnet_map)
}

output "private_zone_id" {
  value = try(aws_route53_zone.PrivateZone[0].zone_id, "")
}

output "vpc_flow_log_id" {
  value = try(aws_flow_log.this[0].id, null)
}

output "vpc_flow_log_destination_arn" {
  value = try(aws_cloudwatch_log_group.this[0].arn, null)
}

output "vpc_flow_log_cloudwatch_iam_role_arn" {
  value = try(aws_iam_role.this[0].arn, null)
}