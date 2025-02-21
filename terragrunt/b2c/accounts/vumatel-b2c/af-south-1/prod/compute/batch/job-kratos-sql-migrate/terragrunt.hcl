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


dependency "sql" {
  config_path = "${dirname(get_original_terragrunt_dir())}/ssa-compute-environment"
}

dependency "kratos-migrate" {
  config_path = "${dirname(get_original_terragrunt_dir())}/../../ecs/services/kratos-sql-migrate"
}

dependency "ecr" {
  config_path = "${dirname(get_original_terragrunt_dir())}/../../data/ecr"
}

# THE REVISION NUMBER CAUSES AN INFINITE DIFF. BUT THE IMAGE BELOW WILL ENSURE THAT THE NEW REVISION IS CONSISTENT.
# THE INFINITE REVISION NUMBER DIFF IS A PROVIDER ISSUE.

inputs = {
  name                   = "kratos-sql-migrate"
  image_url              = "${try(dependency.ecr.outputs.repository_url_map["shared/oryd/kratos"], "")}:latest"
  execution_role_arn     = dependency.kratos-migrate.outputs.task_exec_role_arn
  enable_cron_scheduling = false
  # schedule_expression    = "cron(* * * * * *)"
}
