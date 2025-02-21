include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/network/vpc.hcl"
  expose = true
}

terraform {
  source = "${include.envcommon.locals.base_source_url}"
}

# Note: the Cidr Range will split between availability zones.
inputs = {
  vpc_cidr_block              = "10.185.64.0/18"
  public_subnets_cidr_block   = "10.185.64.0/22"
  private_subnets_cidr_block  = "10.185.80.0/20"
  isolated_subnets_cidr_block = "10.185.72.0/21"
}
