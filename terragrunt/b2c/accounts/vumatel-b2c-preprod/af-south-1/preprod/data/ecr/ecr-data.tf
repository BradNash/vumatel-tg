data "terraform_remote_state" "ecr_data" {
  backend = "s3"
  config = {
    bucket         = "vumatel-platform-tf-state"
    key            = "accounts/vumatel-b2c-preprod/af-south-1/shared/ecr/terraform.tfstate"
    region         = "af-south-1"
    profile        = "vumatel-operations"
    dynamodb_table = "vumatel-platform-terraform-locks"
  }
}

# --------
# Outputs
# --------

output "registry_id" {
  value = data.terraform_remote_state.ecr_data.outputs.registry_id
}

output "repository_name" {
  value = data.terraform_remote_state.ecr_data.outputs.repository_name
}

output "repository_url" {
  value = data.terraform_remote_state.ecr_data.outputs.repository_url
}

output "repository_arn" {
  value = data.terraform_remote_state.ecr_data.outputs.repository_arn
}

output "repository_url_map" {
  value = data.terraform_remote_state.ecr_data.outputs.repository_url_map
}

output "repository_arn_map" {
  value = data.terraform_remote_state.ecr_data.outputs.repository_arn_map
}
