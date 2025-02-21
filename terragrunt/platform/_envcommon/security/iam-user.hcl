locals {
  base_source_url = "git::https://github.com/cloudposse/terraform-aws-iam-user?ref=0.9.0"
}

inputs = {
  login_profile_enabled= false
  user_name = ""
   pgp_key = "" # keybase:ssapipelinebot
  path= "/"
  groups= []
  permissions_boundary= ""
  force_destroy= false
  password_reset_required= false
  password_length= 24
}
