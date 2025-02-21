variable "destination_location_arn" {
  description = "Amazon Resource Name (ARN) of destination DataSync Location."
  type        = string
}

variable "source_location_arn" {
  description = "Amazon Resource Name (ARN) of source DataSync Location."
  type        = string
}

variable "cloudwatch_log_group_arn" {
  description = "Amazon Resource Name (ARN) of the CloudWatch Log Group to monitor and log events in the sync task."
  type        = string
  default     = null
}

variable "excludes" {
  description = "Filter rules to determine which files to exclude from a task."
  type        = list(object({
    filter_type = string
    value       = string
  }))
  default = []
}

variable "includes" {
  description = "Filter rules to determine which files to include in a task."
  type        = list(object({
    filter_type = string
    value       = string
  }))
  default = []
}

variable "options" {
  description = "Configuration block controlling the default behavior when executing the DataSync Task."
  type = object({
    atime                        = optional(string, "BEST_EFFORT")
    bytes_per_second             = optional(number, -1)
    gid                          = optional(string, "INT_VALUE")
    log_level                    = optional(string, "OFF")
    mtime                        = optional(string, "PRESERVE")
    object_tags                  = optional(string, "PRESERVE")
    overwrite_mode               = optional(string, "ALWAYS")
    posix_permissions            = optional(string, "PRESERVE")
    preserve_deleted_files       = optional(string, "PRESERVE")
    preserve_devices             = optional(string, "NONE")
    security_descriptor_copy_flags = optional(string, "OWNER_DACL")
    task_queueing                = optional(string, "ENABLED")
    transfer_mode                = optional(string, "CHANGED")
    uid                          = optional(string, "INT_VALUE")
    verify_mode                  = optional(string, "POINT_IN_TIME_CONSISTENT")
  })
  default = null
}

variable "schedule" {
  description = "Schedule for periodic file transfer."
  type = object({
    schedule_expression = string
  })
  default = null
}

variable "task_report_config" {
  description = "Configuration block for DataSync Task Report."
  type = object({
    s3_destination = object({
      bucket_access_role_arn = string
      s3_bucket_arn          = string
      subdirectory           = optional(string)
    })
    s3_object_versioning = optional(string, "NONE")
    output_type          = optional(string, "SUMMARY_ONLY")
    report_overrides = optional(object({
      deleted_override    = optional(string, "ERRORS_ONLY")
      skipped_override    = optional(string, "ERRORS_ONLY")
      transferred_override = optional(string, "ERRORS_ONLY")
      verified_override   = optional(string, "ERRORS_ONLY")
    }), null)
    report_level = optional(string, "ERRORS_ONLY")
  })
  default = null
}
