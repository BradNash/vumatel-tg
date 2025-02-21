include "root" {
  path = find_in_parent_folders()
}

include "envcommon_services_common" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/ecs/services/_common.hcl"
  expose = true
}

include "envcommon_service" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/ecs/services/kratos-serve.hcl"
  expose = true
}

terraform {
  source = include.envcommon_services_common.locals.base_source_url
}

inputs = {
  listener_host_header    = "auth"
}

