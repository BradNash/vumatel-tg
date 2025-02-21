include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/ecs/ecr.hcl"
  expose = true
}

terraform {
  source = include.envcommon.locals.base_source_url
}

#TODO: DEPRECATED ONCE NETWORK BETWEEN ACCOUNTS IS WORKING
inputs = {
  name                 = "ecr"
  image_tag_mutability = "MUTABLE"
  use_fullname         = true
  force_delete         = true

  image_names = [
    "shared/ealen/echo-server",
    "b2c/customer-details",
    "b2c/device-details",
    "b2c/supergraph",
    "b2c/isp-details",
    "b2c/premises-details",
    "b2c/service-details",
    "b2c/service-links",
    "b2c/support-ticket",
    "b2c/order-details",
    "b2c/incident-details",
    "b2c/payments-service",
    "b2c/voucher-details",
    "b2c/places-search",
    "b2c/profile-details",
    "shared/datadog/agent",
    "b2c/datadog/agent",
    "shared/oryd/kratos",
    "shared/compose-x/ecs-files-composer",
    "shared/amazon/aws-for-fluent-bit"
  ]
  principals_readonly_access = [
    "arn:aws:iam::339712841843:root",
    "arn:aws:iam::992382552351:root",
    "arn:aws:iam::211125628455:root",
    "arn:aws:iam::637423199642:root",
  ]
}
