######
# JOB DEFINITION
######
variable "type" {
  description = "The type of job definition. Must be 'container' or 'multinode'."
  type        = string
}

variable "container_properties" {
  description = "Valid container properties provided as a JSON document. Applicable for type = 'container'."
  type        = string
  default     = ""
}

variable "platform_capabilities" {
  description = "Platform capabilities required by the job definition (e.g., 'EC2' or 'FARGATE')."
  type = list(string)
  default = ["EC2"]
}

variable "image_url" {
  description = "Image URL for the containr properties"
  type = string
  default = "992382552351.dkr.ecr.af-south-1.amazonaws.com/shared/ealen/echo-server"
}

variable "enable_cron_scheduling" {
  description = "Enable cron scheduling"
  type        = bool
  default     = false
}

variable "retry_strategy" {
  description = "Retry strategy"
  type        = number
  default     = 1
}

variable "schedule_expression" {
  description = "Scheduling expression for EventBridge Rule. For example, cron(0 20 * * ? *) or rate(5 minutes)"
  type        = string
  default     = ""
}

variable "batch_queue_arn" {
  description = "Batch Queue ARN to submit job to using EventBridge if enable_cron_scheduling is set to true"
  type        = string
  default     = ""
}

variable "execution_role_arn" {
  description = "Execution role for the batch job"
  type        = string
}

