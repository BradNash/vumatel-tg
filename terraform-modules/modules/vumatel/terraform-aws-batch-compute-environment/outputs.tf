######
# COMPUTE ENVIRONMENT
######
output "compute_environment_arn" {
  description = "The Amazon Resource Name (ARN) of the compute environment."
  value       = aws_batch_compute_environment.default.arn
}

output "ecs_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the underlying Amazon ECS cluster used by the compute environment."
  value       = aws_batch_compute_environment.default.ecs_cluster_arn
}

output "compute_environment_status" {
  description = "The current status of the compute environment (e.g., CREATING, VALID)."
  value       = aws_batch_compute_environment.default.status
}

output "compute_environment_status_reason" {
  description = "Additional details about the current status of the compute environment."
  value       = aws_batch_compute_environment.default.status_reason
}

output "compute_environment_tags_all" {
  description = "A map of all tags assigned to the compute environment, including inherited ones."
  value       = aws_batch_compute_environment.default.tags_all
}


######
# JOB QUEUE
######
output "job_queue_arn" {
  description = "The Amazon Resource Name of the job queue."
  value       = aws_batch_job_queue.default.arn
}

output "job_queue_tags_all" {
  description = "A map of tags assigned to the job queue, including inherited tags."
  value       = aws_batch_job_queue.default.tags_all
}
