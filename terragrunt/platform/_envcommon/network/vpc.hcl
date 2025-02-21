locals {
  base_source_url = "${get_repo_root()}/terraform-modules/modules/cloudposse/terraform-aws-vpc"
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl", "account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl", "environment.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl", "region.hcl"))
}


# The Cidr Range will split between availability zones.
inputs = {
  name = "vpc"
  flow_log_traffic_type                   = "ALL"
  flow_log_max_aggregation_interval       = 600
  flow_log_cloudwatch_log_group_retention = 90

  enable_flow_log             = true
  internet_gateway_enabled    = true
  public_nat_gateway_enabled  = true
  subnet_azs                  = local.region_vars.locals.availability_zones
}
