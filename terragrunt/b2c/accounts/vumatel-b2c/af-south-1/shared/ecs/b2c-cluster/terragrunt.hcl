locals {
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl", "account.hcl"))
}

include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/ecs/ecs-cluster.hcl"
  expose = true
}

terraform {
  source = include.envcommon.locals.base_source_url
}

inputs = {
  enable_slack_notifications = true
  slack_channel_id = "C08B8EFAM7X"
  slack_team_id = "T041DNB19"
}

