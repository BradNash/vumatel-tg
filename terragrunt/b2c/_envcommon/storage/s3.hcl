# For more information on the repository see below.
# https://github.com/cloudposse/terraform-aws-s3-bucket

locals {
  base_source_url  = "git::https://github.com/cloudposse/terraform-aws-s3-bucket?ref=4.7.0"
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl", "account.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl", "region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl", "environment.hcl"))
}

inputs = {
  force_destroy                           = false
  versioning_enabled                      = true
  availability_zone_id                    = local.region_vars.locals.availability_zones

  #   acl                                     = "private"
  #   grants                                  = []
  #   source_policy_documents                 = []
  #   logging                                 = []
  #   sse_algorithm                           = "AES256"
  #   kms_master_key_arn                      = ""
  #   user_enabled                            = false
  #   user_permissions_boundary_arn           = null
  #   access_key_enabled                      = true
  #   store_access_key_in_ssm                 = false
  #   ssm_base_path                           = "/s3_user/"
  #   allowed_bucket_actions                  = [
  #     "s3:PutObject",
  #     "s3:PutObjectAcl",
  #     "s3:GetObject",
  #     "s3:DeleteObject",
  #     "s3:ListBucket",
  #     "s3:ListBucketMultipartUploads",
  #     "s3:GetBucketLocation",
  #     "s3:AbortMultipartUpload"
  #   ]
  #   allow_encrypted_uploads_only            = false
  #   allow_ssl_requests_only                 = false
  #   minimum_tls_version                     = null
  #   lifecycle_configuration_rules           = []
  #   cors_configuration                      = []
  #   block_public_acls                       = true
  #   block_public_policy                     = true
  #   ignore_public_acls                      = true
  #   restrict_public_buckets                 = true
  #   s3_replication_enabled                  = false
  #   s3_replica_bucket_arn                   = ""
  #   s3_replication_rules                    = null
  #   s3_replication_source_roles             = []
  #   s3_replication_permissions_boundary_arn = null
  #   object_lock_configuration               = null
  #   website_redirect_all_requests_to        = []
  #   website_configuration                   = []
  #   privileged_principal_arns = {}
  #   privileged_principal_actions            = []
  #   source_ip_allow_list                    = []
  #   transfer_acceleration_enabled           = false
  #   s3_object_ownership                     = "ObjectWriter"
  #   bucket_key_enabled                      = false
  #   expected_bucket_owner = { enabled = false }
  #   create_s3_directory_bucket              = false
}
