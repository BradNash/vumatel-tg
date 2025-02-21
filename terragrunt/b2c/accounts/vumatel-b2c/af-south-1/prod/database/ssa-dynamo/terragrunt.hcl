include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/database/dynamo.hcl"
  expose = true
}

terraform {
  source = include.envcommon.locals.base_source_url
}

inputs = {
  name          = "ssa-service-links"
  hash_key      = "pk"
  range_key     = "sk"
  ttl_attribute = "expireAt"
}