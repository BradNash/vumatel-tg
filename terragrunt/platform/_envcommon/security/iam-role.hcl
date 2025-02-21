locals {
  base_source_url = "git::https://github.com/cloudposse/terraform-aws-iam-role?ref=v0.20.0"
}

inputs = {
  name                     = ""
  role_description         = ""
  managed_policy_arns = []
  tags_enabled             = true
  use_fullname             = true
  instance_profile_enabled = false
  inline_policy_enabled    = false
  permissions_boundary     = ""
  path                     = "/"
  max_session_duration     = 3600
  assume_role_conditions = []
  assume_role_actions = ["sts:AssumeRole", "sts:TagSession"]
  policy_name              = null
  policy_document_count    = 0
  policy_description       = ""
  principals = {}
  policy_documents = []
}
