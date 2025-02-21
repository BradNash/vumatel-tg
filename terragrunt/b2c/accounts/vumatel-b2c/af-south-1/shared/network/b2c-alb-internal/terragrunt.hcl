include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/network/alb.hcl"
  expose = true
}

terraform {
  source = include.envcommon.locals.base_source_url
}

dependency "vpc" {
  config_path = "${dirname(get_original_terragrunt_dir())}/../data/vpc"
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl", "account.hcl"))
}

inputs = {
  name               = "alb-internal"
  internal           = false
  access_logs_prefix = "ssa-alb-internal"
  https_port         = 443
  https_ingress_cidr_blocks = [dependency.vpc.outputs.vpc_cidr_block]
  https_ssl_policy   = "ELBSecurityPolicy-2015-05"
  http_redirect      = true
  https_enabled      = true
  certificate_arn    = local.account_vars.locals.afs1_certificate_arn 
  subnet_ids         = dependency.vpc.outputs.public_az_subnet_ids
  vpc_id             = dependency.vpc.outputs.vpc_id

  # Only Allow staff IP's
  https_ingress_cidr_blocks = ["169.1.91.54/32"]
}
