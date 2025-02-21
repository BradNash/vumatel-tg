locals {
  base_source_url = "git::https://github.com/cloudposse/terraform-aws-efs"
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl", "account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl", "environment.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl", "region.hcl"))
}

dependency "vpc" {
  config_path = "${dirname(get_original_terragrunt_dir())}/../../../shared/network/vpc"
}


inputs = {
  vpc_id                    = dependency.vpc.outputs.vpc_id
  region                    = local.region_vars.locals.aws_region
  efs_backup_policy_enabled = true
  # TODO: INVESTIGATE WHY SUBNET IDS ARE NOT WORKING (dependency.vpc.outputs.private_az_subnet_ids)
  # subnets = dependency.vpc.outputs.private_az_subnet_ids
  subnets = ["subnet-09e85c24eb0b03d67", "subnet-0a88bc18c413b0b50"]
  allowed_cidr_blocks = [dependency.vpc.outputs.vpc_cidr_block]

  # encrypted                          = true
  # kms_key_id                         = null
  # performance_mode                   = "generalPurpose"
  # provisioned_throughput_in_mibps    = 0
  # throughput_mode                    = "bursting"
  # mount_target_ip_address            = null
  # dns_name                           = ""
  # bypass_policy_lockout_safety_check = false
  # availability_zone_name             = null
  # access_points = {}
  # zone_id = []
  # transition_to_archive = []
  # transition_to_ia = []
  # transition_to_primary_storage_class = []

}
