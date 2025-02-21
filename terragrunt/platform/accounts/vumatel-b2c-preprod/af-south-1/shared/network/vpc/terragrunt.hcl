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

# The Cidr Range will split between availability zones.
inputs = {
  vpc_cidr_block              = "10.186.64.0/18"
  public_subnets_cidr_block   = "10.186.64.0/22"
  private_subnets_cidr_block  = "10.186.80.0/20"
  isolated_subnets_cidr_block = "10.186.72.0/21"

  # Allow public subnet to connect to isolated subnet for NLB forwarding, TODO: Remove once VPN setup is done
  semi_isolated_routed_subnets = ["10.186.64.0/22"]
}
