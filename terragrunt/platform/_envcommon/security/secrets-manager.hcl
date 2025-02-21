locals {
  base_source_url = "${get_repo_root()}/terraform-modules/modules/vumatel/terraform-aws-secrets-manager"
}

inputs = {
  base64_encode_secret = false
  rotate_secret        = false
  rotation_rules = {
    automatically_after_days = 30
    schedule_expression      = ""
    duration                 = ""
  }
#   kms_key_id                     = "aws/secretsmanager"
#   name_prefix                    = ""
#   policy                         = ""
#   recovery_window_in_days        = 0
#   replica                        = []
#   force_overwrite_replica_secret = false
#   version_stages                 = []
#   rotate_immediately             = true
#   rotation_lambda_arn            = ""
#   length                         = 20
#   lower                          = true
#   min_lower                      = 0
#   min_numeric                    = 0
#   min_special                    = 0
#   min_upper                      = 0
#   numeric                        = true
#   override_special               = ""
#   special                        = true
#   upper                          = true
#   keepers = {}
}
