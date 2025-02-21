include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/security/iam-system-user.hcl"
  expose = true
}

terraform {
  source = include.envcommon.locals.base_source_url
}

inputs = {
  name        = "ssa-pipeline-bot"
  user_name   = "ssa-pipeline-bot"
  policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}