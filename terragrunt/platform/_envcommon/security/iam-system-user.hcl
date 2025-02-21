locals {
  base_source_url = "git::https://github.com/cloudposse/terraform-aws-iam-system-user?ref=1.2.1"
}

inputs = {
  force_destroy= false
  path= "/"
  inline_policies= []
  inline_policies_map= {}
  policy_arns= []
  policy_arns_map= {}
  permissions_boundary= null
  create_iam_access_key= true
  ssm_enabled= true
  ssm_ses_smtp_password_enabled= false
  ssm_base_path= "/system_user/"
}
