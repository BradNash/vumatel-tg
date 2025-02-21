# For more information on the repository see below.
# https://github.com/cloudposse/terraform-aws-cloudfront-s3-cdn

locals {
  base_source_url  = "git::https://github.com/cloudposse/terraform-aws-cloudfront-s3-cdn.git?ref=0.95.0"
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl", "account.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl", "region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl", "environment.hcl"))
}

inputs = {
  acm_certificate_arn  = local.account_vars.locals.use1_certificate_arn
  cors_allowed_headers = ["*"]
  cors_allowed_methods = ["GET"]
  cors_allowed_origins = ["*"]
  allowed_methods      = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  default_ttl          = 60
  min_ttl              = 0
  max_ttl              = 31536000
  bucket_versioning    = "Enabled"
  s3_object_ownership  = "BucketOwnerPreferred"

  website_enabled                   = false
  logging_enabled                   = false
  s3_access_logging_enabled         = false
  cloudfront_access_logging_enabled = false

  #   origin_path                   = ""
  #   deployment_actions            = [
  #     "s3:PutObject",
  #     "s3:PutObjectAcl",
  #     "s3:GetObject",
  #     "s3:DeleteObject",
  #     "s3:ListBucket",
  #     "s3:ListBucketMultipartUploads",
  #     "s3:GetBucketLocation",
  #     "s3:AbortMultipartUpload",
  #     "s3:PutBucketAcl"
  #   ]
  #   s3_access_log_bucket_name   = ""
  #   geo_restriction_type          = "none"
  #   geo_restriction_locations     = []
  #   extra_origin_attributes       = ["origin"]
  #   default_root_object           = ""
  #   index_document                = "index.html"
  #   error_document                = ""
  #   minimum_protocol_version      = ""
  #   external_aliases              = []
  #   additional_bucket_policy      = "{}"
  #   override_origin_bucket_policy = true
  #   origin_force_destroy          = false
  #   compress                      = true
  #   log_standard_transition_days  = 30
  #   log_glacier_transition_days   = 60
  #   log_expiration_days           = 90
  #   log_versioning_enabled        = false
  #   forward_query_string          = false
  #   query_string_cache_keys       = []
  #   cors_expose_headers           = ["ETag"]
  #   cors_max_age_seconds          = 3600
  #   forward_cookies               = "none"
  #   forward_header_values         = ["Access-Control-Request-Headers", "Access-Control-Request-Method", "Origin"]
  #   price_class                   = "PriceClass_100"
  #   response_headers_policy_id    = ""
  #   viewer_protocol_policy        = "redirect-to-https"
  #   cached_methods                = ["GET", "HEAD"]
  #   cache_policy_id               = null
  #   origin_request_policy_id      = null
  #   trusted_signers               = []
  #   trusted_key_groups            = []
  #   parent_zone_id                = null
  #   parent_zone_name              = ""
  #   dns_alias_enabled             = false
  #   dns_allow_overwrite           = false
  #   custom_error_response         = []
  #   lambda_function_association   = []
  #   function_association          = []
  #   web_acl_id                    = ""
  #   wait_for_deployment           = true
  #   encryption_enabled            = true
  #   redirect_all_requests_to      = ""
  #   routing_rules                 = ""
  #   ipv6_enabled                  = true
  #   ordered_cache                 = []
  #   custom_origins                = []
  #   s3_origins                    = []
  #   versioning_enabled            = true
  #   deployment_principal_arns = {}
  #   cloudfront_origin_access_identity_iam_arn = ""
  #   cloudfront_origin_access_identity_path    = ""
  #   custom_origin_headers                     = []
  #   origin_ssl_protocols                      = ["TLSv1", "TLSv1.1", "TLSv1.2"]
  #   block_origin_public_access_enabled        = false
  #   s3_access_log_prefix                      = ""
  #   cloudfront_access_log_create_bucket       = false
  #   cloudfront_access_log_prefix              = ""
  #   origin_bucket                             = null
  #   extra_logs_attributes                     = ["logs"]
  #   cloudfront_access_log_bucket_name         = ""
  #   cloudfront_access_log_include_cookies     = false
  #   distribution_enabled                      = true
  #   s3_website_password_enabled               = false
  #   origin_groups                             = []
  #   access_log_bucket_name                    = null
  #   log_include_cookies                       = null
  #   log_prefix                                = null
  #   realtime_log_config_arn                   = null
  #   allow_ssl_requests_only                   = true
  #   origin_shield_enabled                     = false
  #   http_version                              = "http2"
}
