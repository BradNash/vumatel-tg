include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/network/security-group.hcl"
  expose = true
}

terraform {
  source = include.envcommon.locals.base_source_url
}

dependency "vpc" {
  config_path = "${dirname(get_original_terragrunt_dir())}/../../data/vpc"
}

dependency "alb" {
  config_path = "${dirname(get_original_terragrunt_dir())}/../../../shared/network/b2c-alb"
}

inputs = {
  vpc_id                     = dependency.vpc.outputs.vpc_id
  name                       = "ssa-inter-service-sg"
  security_group_description = "Self service app security group for all services associated with the ssa app"
  allow_all_egress           = true
  create_before_destroy      = false
  rules                      = [
    {
      type                     = "ingress"
      description              = "Allow all traffic from self for container communication"
      from_port                = 0
      to_port                  = 0
      protocol                 = "-1"
      cidr_blocks              = []
      ipv6_cidr_blocks         = []
      source_security_group_id = null
      self                     = true
    }
  ]

  #   target_security_group_id      = []
  #   preserve_security_group_id    = false
  #   rules_map = {}
  #   rule_matrix                   = []
  #   security_group_create_timeout = "10m"
  #   security_group_delete_timeout = "15m"
  #   revoke_rules_on_delete        = false
  #   inline_rules_enabled          = false
}

