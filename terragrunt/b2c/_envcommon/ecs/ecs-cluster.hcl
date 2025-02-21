locals {
  #   base_source_url  = "git::https://github.com/cloudposse/terraform-aws-ecs-cluster.git?ref=0.6.1"
  base_source_url  = "${get_repo_root()}/terraform-modules/modules/cloudposse/terraform-aws-ecs-cluster"
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl", "account.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl", "region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl", "environment.hcl"))
}

dependency "vpc" {
  config_path = "${dirname(get_original_terragrunt_dir())}/../data/vpc"
}

inputs = {
  name                            = "cluster"
  vpc_id                          = dependency.vpc.outputs.vpc_id
  container_insights_enabled      = false
  capacity_providers_fargate_spot = true
  dns_namespace_name              = "${local.environment_vars.locals.environment}.internal"

  default_capacity_strategy = {
    base = {
      provider = "FARGATE_SPOT"
      value    = 1
    }
    weights = {
      FARGATE_SPOT = 1
      FARGATE      = 0
    }
  }
}
