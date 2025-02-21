include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/security/ssm.hcl"
  expose = true
}

terraform {
  source = include.envcommon.locals.base_source_url
}

inputs = {
  name                     = "expo-bot-access-token"
  secret_map = {
    ACCESS_TOKEN           = "ACCESS_TOKEN"
  }
}
