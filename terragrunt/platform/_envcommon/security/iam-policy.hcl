locals {
  base_source_url = "git::https://github.com/cloudposse/terraform-aws-iam-policy?ref=2.0.1"
}

inputs = {
  iam_policy                    = []
  iam_policy_enabled            = true
#   description                   = null
#   iam_source_json_url           = null
#   iam_source_policy_documents   = null
#   iam_override_policy_documents = null
}
