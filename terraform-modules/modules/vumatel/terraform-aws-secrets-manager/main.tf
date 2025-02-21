locals {
  passwords = var.generate_random_password && length(var.password_names) > 0 ? [for i in range(length(var.password_names)) : random_password.default[i].result] : []
  name_password_map = {
    for idx, name in var.password_names : name => local.passwords[idx]
    if !contains(keys(var.secret_map), name)
  }
  secret_map_merged = length(local.name_password_map) > 0 ? merge(var.secret_map, local.name_password_map) : var.secret_map
  secret_string = var.base64_encode_secret == false ? jsonencode(local.secret_map_merged) : null
  secret_binary = var.base64_encode_secret == true ? base64encode(jsonencode(local.secret_map_merged)) : null

  rotation_count = var.rotate_secret ? 1 : 0
}

resource "aws_secretsmanager_secret" "default" {
  name                           = module.this.id
  description                    = "Secret value for ${module.this.id}"
  kms_key_id                     = var.kms_key_id
  name_prefix                    = var.name_prefix
  policy                         = var.policy
  recovery_window_in_days        = var.recovery_window_in_days
  force_overwrite_replica_secret = var.force_overwrite_replica_secret
  tags                           = module.this.tags

  dynamic "replica" {
    for_each = var.replica
    content {
      region     = replica.value.region
      kms_key_id = replica.value.kms_key_id
    }
  }
}

#resource "aws_secretsmanager_secret_version" "default" {
#  secret_id      = aws_secretsmanager_secret.default.id
#  secret_string  = local.secret_string
#  secret_binary  = local.secret_binary
#  version_stages = var.version_stages
#}

resource "aws_secretsmanager_secret_rotation" "default" {
  count               = local.rotation_count
  secret_id           = aws_secretsmanager_secret.default.id
  rotation_lambda_arn = var.rotation_lambda_arn
  rotate_immediately  = var.rotate_immediately

  # Conditionally include the rotation_rules block if any of its fields are set
  rotation_rules {
    automatically_after_days = lookup(var.rotation_rules, "automatically_after_days", 0)
    duration                 = lookup(var.rotation_rules, "duration", "")
    schedule_expression      = lookup(var.rotation_rules, "schedule_expression", "")
  }
}


resource "random_password" "default" {
  count            = var.generate_random_password && length(var.password_names) > 0 ? length(var.password_names) : 0
  length           = var.length
  keepers          = var.keepers
  lower            = var.lower
  min_lower        = var.min_lower
  min_numeric      = var.min_numeric
  min_special      = var.min_special
  min_upper        = var.min_upper
  numeric          = var.numeric
  override_special = var.override_special
  special          = var.special
  upper            = var.upper
}
