data "terraform_remote_state" "vpc_data" {
  backend = "s3"
  config = {
    bucket         = "vumatel-platform-tf-state"
    key            = "accounts/vumatel-b2c/af-south-1/shared/network/vpc/terraform.tfstate"
    region         = "af-south-1"
    profile        = "vumatel-operations"
    dynamodb_table = "vumatel-platform-terraform-locks"
  }
}

# --------
# Outputs
# --------

output "vpc_id" {
  value = data.terraform_remote_state.vpc_data.outputs.vpc_id
}

output "vpc_cidr_block" {
  value = data.terraform_remote_state.vpc_data.outputs.vpc_cidr_block
}

output "vpc_default_network_acl_id" {
  value = data.terraform_remote_state.vpc_data.outputs.vpc_default_network_acl_id
}

output "vpc_default_route_table_id" {
  value = data.terraform_remote_state.vpc_data.outputs.vpc_default_route_table_id
}

output "vpc_default_security_group_id" {
  value = data.terraform_remote_state.vpc_data.outputs.vpc_default_security_group_id
}

output "vpc_flow_log_cloudwatch_iam_role_arn" {
  value = data.terraform_remote_state.vpc_data.outputs.vpc_flow_log_cloudwatch_iam_role_arn
}

output "vpc_flow_log_destination_arn" {
  value = data.terraform_remote_state.vpc_data.outputs.vpc_flow_log_destination_arn
}

output "vpc_flow_log_id" {
  value = data.terraform_remote_state.vpc_data.outputs.vpc_flow_log_id
}

output "vpc_main_route_table_id" {
  value = data.terraform_remote_state.vpc_data.outputs.vpc_main_route_table_id
}

output "igw_id" {
  value = data.terraform_remote_state.vpc_data.outputs.igw_id
}

output "isolated_az_ngw_ids" {
  value = values(data.terraform_remote_state.vpc_data.outputs.isolated_az_ngw_ids)
}

output "isolated_az_route_table_ids" {
  value = values(data.terraform_remote_state.vpc_data.outputs.isolated_az_route_table_ids)
}

output "isolated_az_subnet_arns" {
  value = values(data.terraform_remote_state.vpc_data.outputs.isolated_az_subnet_arns)
}

output "isolated_az_subnet_cidr_blocks" {
  value = values(data.terraform_remote_state.vpc_data.outputs.isolated_az_subnet_cidr_blocks)
}

output "isolated_az_subnet_ids" {
  value = values(data.terraform_remote_state.vpc_data.outputs.isolated_az_subnet_ids)
}

output "isolated_az_subnet_map" {
  value = data.terraform_remote_state.vpc_data.outputs.isolated_az_subnet_map
}

output "private_az_ngw_ids" {
  value = values(data.terraform_remote_state.vpc_data.outputs.private_az_ngw_ids)
}

output "private_az_route_table_ids" {
  value = values(data.terraform_remote_state.vpc_data.outputs.private_az_route_table_ids)
}

output "private_az_subnet_arns" {
  value = values(data.terraform_remote_state.vpc_data.outputs.private_az_subnet_arns)
}

output "private_az_subnet_cidr_blocks" {
  value = values(data.terraform_remote_state.vpc_data.outputs.private_az_subnet_cidr_blocks)
}

output "private_az_subnet_ids" {
  value = values(data.terraform_remote_state.vpc_data.outputs.private_az_subnet_ids)
}

output "private_az_subnet_map" {
  value = data.terraform_remote_state.vpc_data.outputs.private_az_subnet_map
}

output "public_az_ngw_ids" {
  value = values(data.terraform_remote_state.vpc_data.outputs.public_az_ngw_ids)
}

output "public_az_route_table_ids" {
  value = values(data.terraform_remote_state.vpc_data.outputs.public_az_route_table_ids)
}

output "public_az_subnet_arns" {
  value = values(data.terraform_remote_state.vpc_data.outputs.public_az_subnet_arns)
}

output "public_az_subnet_cidr_blocks" {
  value = values(data.terraform_remote_state.vpc_data.outputs.public_az_subnet_cidr_blocks)
}

output "public_az_subnet_ids" {
  value = values(data.terraform_remote_state.vpc_data.outputs.public_az_subnet_ids)
}

output "public_az_subnet_map" {
  value = data.terraform_remote_state.vpc_data.outputs.public_az_subnet_map
}
