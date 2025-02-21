######
# JOB DEFINITION
######
output "job_definition_arn" {
  description = "The ARN of the job definition, including revision."
  value       = aws_batch_job_definition.default.arn
}

output "job_definition_arn_prefix" {
  description = "The ARN of the job definition without the revision."
  value       = aws_batch_job_definition.default.arn_prefix
}

output "job_definition_revision" {
  description = "The revision number of the job definition."
  value       = aws_batch_job_definition.default.revision
}

output "job_definition_tags_all" {
  description = "Map of all tags assigned to the job definition, including inherited tags."
  value       = aws_batch_job_definition.default.tags_all
}
