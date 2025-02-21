# For more information on the repository see below.
# https://github.com/cloudposse/terraform-aws-alb

locals {
  base_source_url  = "${get_repo_root()}/terraform-modules/modules/cloudposse/terraform-aws-api-gateway"
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl", "account.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl", "region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl", "environment.hcl"))
}

dependency "vpc" {
  config_path = "${dirname(get_original_terragrunt_dir())}/../data/vpc"
}

inputs = {
  endpoint_type        = "REGIONAL"
  logging_level        = "INFO"
  metrics_enabled      = false
  xray_tracing_enabled = false

  #   rest_api_policy          = null
  #   private_link_target_arns = []
  #   iam_tags_enabled         = true
  #   permissions_boundary     = ""
  #   data_trace_enabled       = false
  #   access_log_format        = <<EOF
  #   {
  # 	"requestTime": "$context.requestTime",
  # 	"requestId": "$context.requestId",
  # 	"httpMethod": "$context.httpMethod",
  # 	"path": "$context.path",
  # 	"resourcePath": "$context.resourcePath",
  # 	"status": $context.status,
  # 	"responseLatency": $context.responseLatency,
  #     "xrayTraceId": "$context.xrayTraceId",
  #     "integrationRequestId": "$context.integration.requestId",
  # 	"functionResponseStatus": "$context.integration.status",
  #     "integrationLatency": "$context.integration.latency",
  # 	"integrationServiceStatus": "$context.integration.integrationStatus",
  #     "authorizeResultStatus": "$context.authorize.status",
  # 	"authorizerServiceStatus": "$context.authorizer.status",
  # 	"authorizerLatency": "$context.authorizer.latency",
  # 	"authorizerRequestId": "$context.authorizer.requestId",
  #     "ip": "$context.identity.sourceIp",
  # 	"userAgent": "$context.identity.userAgent",
  # 	"principalId": "$context.authorizer.principalId",
  # 	"cognitoUser": "$context.identity.cognitoIdentityId",
  #     "user": "$context.identity.user"
  #   }
  #   EOF
}
