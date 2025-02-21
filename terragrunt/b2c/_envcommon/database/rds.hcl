# For more information on the repository see below.
# https://github.com/cloudposse/terraform-aws-rds

locals {
  base_source_url = "${get_repo_root()}/terraform-modules/modules/cloudposse/terraform-aws-rds"
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl", "account.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl", "region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl", "environment.hcl"))
}

dependency "vpc" {
  config_path = "${dirname(get_original_terragrunt_dir())}/../data/vpc"
}

dependency "nlb" {
  config_path = "${dirname(get_original_terragrunt_dir())}/../network/b2c-nlb"
}

inputs = {
  name                                 = "db"
  database_name                        = "b2c"
  database_user                        = "b2c_admin"
  engine                               = "postgres"
  storage_type                         = "gp3"
  nlb_arn                              = dependency.nlb.outputs.default_target_group_arn
  register_nlb                         = true
  vpc_id                               = dependency.vpc.outputs.vpc_id
  subnet_ids                           = dependency.vpc.outputs.isolated_az_subnet_ids
  availability_zone                    = tolist(local.region_vars.locals.availability_zones)[0]
  allowed_cidr_blocks                  = dependency.vpc.outputs.private_az_subnet_cidr_blocks
  attributes = ["postgres"]
  security_group_ids = [dependency.nlb.outputs.security_group_id]
  database_port                        = 5432
  allocated_storage                    = 20
  max_allocated_storage                = 40
  engine_version                       = 16.3
  backup_retention_period              = 1
  database_manage_master_user_password = true
  multi_az                             = false
  publicly_accessible                  = false
  deletion_protection                  = true
  storage_encrypted                    = true
  apply_immediately                    = true
  instance_class                       = "db.t3.micro"
  db_parameter_group                   = "postgres16"
  ca_cert_identifier                   = "rds-ca-ecc384-g1"
  backup_window                        = "18:00-20:00"
  maintenance_window                   = "Sun:22:00-Sun:23:00"
  proxy_configuration = {}
  performance_insights_enabled         = true
  performance_insights_retention_period = 7

  # dns_zone_id = ""
  # host_name = "db"
  # associate_security_group_ids = []
  # database_password = null
  # database_manage_master_user_password = false
  # database_master_user_secret_kms_key_id = null
  # iops = null
  # storage_throughput = null
  # major_engine_version = ""
  # charset_name = null
  # license_model = ""
  # availability_zone = null
  # db_subnet_group_name = null
  # auto_minor_version_upgrade = true
  # allow_major_version_upgrade = false
  # skip_final_snapshot = true
  # copy_tags_to_snapshot = true
  # db_options = []
  # snapshot_identifier = ""
  # final_snapshot_identifier = ""
  # parameter_group_name = ""
  # option_group_name = ""
  # kms_key_arn = ""
  # performance_insights_enabled = false
  # performance_insights_kms_key_id = null
  # performance_insights_retention_period = 7
  # enabled_cloudwatch_logs_exports = []
  # monitoring_interval = "0"
  # monitoring_role_arn = null
  # iam_database_authentication_enabled = false
  # replicate_source_db = null
  # timezone = null
  # timeouts = {}
  # restore_to_point_in_time = null
}

