output "datasync_task_id" {
  description = "Amazon Resource Name (ARN) of the DataSync Task."
  value       = aws_datasync_task.example.id
}

output "datasync_task_arn" {
  description = "Amazon Resource Name (ARN) of the DataSync Task."
  value       = aws_datasync_task.example.arn
}

output "datasync_task_tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_datasync_task.example.tags_all
}
