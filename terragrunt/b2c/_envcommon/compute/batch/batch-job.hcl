# For more information on the repository see below.
# https://github.com/cloudposse/terraform-aws-batch-jobs

locals {
  base_source_url = "${get_repo_root()}/terraform-modules/modules/vumatel/terraform-aws-batch-jobs"
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl", "account.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl", "region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl", "environment.hcl"))
}

dependency "compute-environment" {
  config_path = "${dirname(get_original_terragrunt_dir())}/ssa-compute-environment"
}

inputs = {
  type                 = "container"
  batch_queue_arn      = dependency.compute-environment.outputs.job_queue_arn
  platform_capabilities = ["FARGATE"]
  # container_properties = ""
  # enable_cron_scheduling=false
  # schedule_expression=""

}

