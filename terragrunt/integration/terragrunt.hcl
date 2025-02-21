locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl", "account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl", "region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl", "environment.hcl"))

  # Extract the variables we need for easy access
  account_name = local.account_vars.locals.account_name
  account_id   = local.account_vars.locals.aws_account_id
  aws_region   = local.region_vars.locals.aws_region
  aws_profile = local.account_vars.locals.aws_profile

  # Context variables
  context = {
    namespace           = "integration"
    environment         = local.environment_vars.locals.environment
    delimiter           = "-"
    label_key_case      = "lower"
    label_order    = ["name", "environment"]
    labels_as_tags = []

    tags = {
      ManagementTeam  = "Devops Team"
      BusinessUnit    = "Integrations"
      Environment     = local.environment_vars.locals.environment
      CreatedBy       = "Terraform"
    }
#     tags_base = {
#       cost-center = ""
#       owner       = ""
#       environment = local.account_vars.locals.environment
#     }

  }

  state_bucket_region      = local.aws_region
  state_bucket_region_abbr = local.region_vars.locals.region_code
  state_bucket_environment = "integration"
  state_bucket_prefix      = "vumatel-${local.state_bucket_environment}"
  state_bucket_profile     = "vumatel-operations"
  state_bucket_role        = "vumatel-integration-tfstate"
  state_bucket_account_id  = "866644257938"
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    terraform {
      required_version = ">= 1.0"
      required_providers {
        aws = {
          source  = "hashicorp/aws"
          version = "~> 5.0"
        }
      }
    }
    provider "aws" {
      region = "${local.aws_region}"
      profile = "${local.aws_profile}"
      default_tags {
        tags = {}
      }
    }
  EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "${local.state_bucket_prefix}-tf-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.state_bucket_region}"
    dynamodb_table = "${local.state_bucket_prefix}-terraform-locks"
    profile        = "${local.state_bucket_profile}"

    s3_bucket_tags = {
      Name        = "${local.state_bucket_prefix}-terraform-state"
      environment = local.context.environment
      cost-center = "AEX"
      owner       = "DEVOPS TEAM"
    }

  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

inputs = merge(
  local.context,
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals
)