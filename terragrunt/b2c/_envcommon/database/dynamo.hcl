# For more information on the repository see below.
# https://github.com/cloudposse/terraform-aws-dynamodb

locals {
  base_source_url  = "git::https://github.com/cloudposse/terraform-aws-dynamodb.git?ref=0.36.0"
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl", "account.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl", "region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl", "environment.hcl"))
}


inputs = {
  billing_mode = "PAY_PER_REQUEST"

  #   ttl_attribute                      = "Expires"
  #   hash_key_type                      = "S"
  #   range_key                          = ""
  #   range_key_type                     = "S"
  #   ttl_enabled                        = true
  #   autoscale_write_target             = 50
  #   autoscale_read_target              = 50
  #   autoscale_min_read_capacity        = 5
  #   autoscale_max_read_capacity        = 20
  #   autoscale_min_write_capacity       = 5
  #   autoscale_max_write_capacity       = 20
  #   enable_streams                     = false
  #   stream_view_type                   = ""
  #   enable_encryption                  = true
  #   server_side_encryption_kms_key_arn = null
  #   enable_point_in_time_recovery      = true
  #   enable_autoscaler                  = false
  #   autoscaler_attributes              = []
  #   autoscaler_tags = {}
  #   dynamodb_attributes                = []
  #   global_secondary_index_map         = []
  #   local_secondary_index_map          = []
  #   replicas                           = []
  #   tags_enabled                       = true
  #   table_class                        = "STANDARD"
  #   deletion_protection_enabled        = false
  #   import_table                       = null
  #   table_name                             = null
}

