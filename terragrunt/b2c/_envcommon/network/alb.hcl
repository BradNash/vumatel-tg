# For more information on the repository see below.
# https://github.com/cloudposse/terraform-aws-alb

locals {
  base_source_url = "git::https://github.com/cloudposse/terraform-aws-alb?ref=1.11.1"
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl", "account.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl", "region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl", "environment.hcl"))
}

dependency "vpc" {
  config_path = "${dirname(get_original_terragrunt_dir())}/../data/vpc"
}
