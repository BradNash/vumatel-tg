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

inputs = {
  vpc_id                     = dependency.vpc.outputs.vpc_id
  name                       = "ssa-batch-compute-sg"
  security_group_description = "Self service app security group for all AWS Compute environment"
  allow_all_egress           = true
  create_before_destroy      = false
  rules                      = [
    {
      type                     = "ingress"
      description              = "Allow all traffic from self for container communication"
      from_port                = 0
      to_port                  = 0
      protocol                 = "tcp"
      cidr_blocks              = [dependency.vpc.outputs.vpc_cidr_block]
      ipv6_cidr_blocks         = []
      source_security_group_id = null
      self                     = false
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

