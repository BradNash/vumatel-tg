include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/network/nlb.hcl"
  expose = true
}

terraform {
  source = include.envcommon.locals.base_source_url
}

inputs = {
    target_group_enabled= true
    target_group_name= "port-forwarding-34345-5432"
    target_group_port= 5432
    access_logs_prefix= "nlb-db-proxy"
    tcp_port= 34345
    health_check_port= 5432
}