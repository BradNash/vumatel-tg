# For more information on the repository see below.
# https://github.com/cloudposse/terraform-aws-security-group

locals {
  base_source_url  = "git::https://github.com/cloudposse/terraform-aws-security-group?ref=2.2.0"
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl", "account.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl", "region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl", "environment.hcl"))
}

# vpc_id                        = ""
# name                          = ""
# security_group_description    = ""
# allow_all_egress              = true
# create_before_destroy         = false
# preserve_security_group_id    = false
# revoke_rules_on_delete        = false
# inline_rules_enabled          = false
# security_group_create_timeout = "10m"
# security_group_delete_timeout = "15m"
# rules                         = []
# target_security_group_id      = []
# rule_matrix                   = []
# rules_map = {}
