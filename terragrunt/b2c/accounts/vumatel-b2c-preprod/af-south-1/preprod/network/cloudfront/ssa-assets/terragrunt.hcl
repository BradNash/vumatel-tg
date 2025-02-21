include "root" {
  path = find_in_parent_folders()
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl", "environment.hcl"))
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/network/cloudfront.hcl"
  expose = true
}

terraform {
  source = include.envcommon.locals.base_source_url
}

inputs = {
  name             = "vumatel-ssa-assets"
  comment          = "Self Service App Front End"
  external_aliases = ["ssa-assets-preprod.vumatel.co.za"]
}
