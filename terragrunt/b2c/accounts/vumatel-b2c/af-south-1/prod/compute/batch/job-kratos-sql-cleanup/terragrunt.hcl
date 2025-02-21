include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/compute/batch/batch-job.hcl"
  expose = true
}

terraform {
  source = include.envcommon.locals.base_source_url
}

dependency "kratos-cleanup" {
  config_path = "${dirname(get_original_terragrunt_dir())}/../../ecs/services/kratos-sql-cleanup"
}

dependency "ecr" {
  config_path = "${dirname(get_original_terragrunt_dir())}/../../data/ecr"
}

# THE REVISION NUMBER CAUSES AN INFINITE DIFF. BUT THE IMAGE BELOW WILL ENSURE THAT THE NEW REVISION IS CONSISTENT.
# THE INFINITE REVISION NUMBER DIFF IS A PROVIDER ISSUE.

inputs = {
  name                   = "kratos-sql-cleanup"
  execution_role_arn     = dependency.kratos-cleanup.outputs.task_exec_role_arn
  image_url              = try(dependency.ecr.outputs.repository_url_map["shared/oryd/kratos"], "")
  enable_cron_scheduling = true
  schedule_expression    = "cron(15 20 ? * SUN *)"
}


