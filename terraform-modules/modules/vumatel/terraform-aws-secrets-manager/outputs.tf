output "secret_arn" {
  description = "The ARN of the secret."
  value       = aws_secretsmanager_secret.default.arn
}

output "secret_id" {
  description = "The ID (ARN) of the secret."
  value       = aws_secretsmanager_secret.default.id
}

output "secret_replica" {
  description = "Attributes of the replica, including last accessed date, status, and status message."
  value       = aws_secretsmanager_secret.default.replica
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_secretsmanager_secret.default.tags_all
}

#output "secret_version_arn" {
#  description = "The ARN of the secret version."
#  value       = aws_secretsmanager_secret_version.default.arn
#}
#
#output "secret_version_id" {
#  description = "A pipe-delimited combination of the secret ID and version ID."
#  value       = aws_secretsmanager_secret_version.default.id
#}
#
#output "secret_version_version_id" {
#  description = "The unique identifier of the version of the secret."
#  value       = aws_secretsmanager_secret_version.default.version_id
#}


# output "rotation_secret_id" {
#   description = "The ID (ARN) of the secret with rotation enabled."
#   value       = aws_secretsmanager_secret_rotation.default[0].id
# }
#
# output "rotation_enabled" {
#   description = "Specifies whether automatic rotation is enabled for this secret."
#   value       = aws_secretsmanager_secret_rotation.default[0].rotation_enabled
# }
