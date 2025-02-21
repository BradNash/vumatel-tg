locals {
  base_source_url = "${get_repo_root()}/terraform-modules/modules/vumatel/terraform-aws-datasync"
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl", "account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl", "environment.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl", "region.hcl"))
}

inputs = {
  # cloudwatch_log_group_arn = ""
  # options                  = null
  # schedule                 = null
  # task_report_config       = null
  # excludes = []
  # includes = []
}
