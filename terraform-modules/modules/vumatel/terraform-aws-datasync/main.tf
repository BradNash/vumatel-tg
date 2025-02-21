resource "aws_datasync_task" "example" {
  name                     = module.this.id
  destination_location_arn = var.destination_location_arn
  source_location_arn      = var.source_location_arn
  cloudwatch_log_group_arn = var.cloudwatch_log_group_arn

  dynamic "excludes" {
    for_each = var.excludes
    content {
      filter_type = excludes.value.filter_type
      value       = excludes.value.value
    }
  }

  dynamic "includes" {
    for_each = var.includes
    content {
      filter_type = includes.value.filter_type
      value       = includes.value.value
    }
  }

  dynamic "options" {
    for_each = var.options != null ? [var.options] : []
    content {
      atime                        = options.value.atime
      bytes_per_second             = options.value.bytes_per_second
      gid                          = options.value.gid
      log_level                    = options.value.log_level
      mtime                        = options.value.mtime
      object_tags                  = options.value.object_tags
      overwrite_mode               = options.value.overwrite_mode
      posix_permissions            = options.value.posix_permissions
      preserve_deleted_files       = options.value.preserve_deleted_files
      preserve_devices             = options.value.preserve_devices
      security_descriptor_copy_flags = options.value.security_descriptor_copy_flags
      task_queueing                = options.value.task_queueing
      transfer_mode                = options.value.transfer_mode
      uid                          = options.value.uid
      verify_mode                  = options.value.verify_mode
    }
  }

  dynamic "schedule" {
    for_each = var.schedule != null ? [var.schedule] : []
    content {
      schedule_expression = schedule.value.schedule_expression
    }
  }

  dynamic "task_report_config" {
    for_each = var.task_report_config != null ? [var.task_report_config] : []
    content {
      s3_destination {
        bucket_access_role_arn = task_report_config.value.s3_destination.bucket_access_role_arn
        s3_bucket_arn          = task_report_config.value.s3_destination.s3_bucket_arn
        subdirectory           = task_report_config.value.s3_destination.subdirectory
      }

      s3_object_versioning = task_report_config.value.s3_object_versioning
      output_type          = task_report_config.value.output_type

      dynamic "report_overrides" {
        for_each = task_report_config.value.report_overrides != null ? [task_report_config.value.report_overrides] : []
        content {
          deleted_override    = report_overrides.value.deleted_override
          skipped_override    = report_overrides.value.skipped_override
          transferred_override = report_overrides.value.transferred_override
          verified_override   = report_overrides.value.verified_override
        }
      }

      report_level = task_report_config.value.report_level
    }
  }
  tags = module.this.tags
}
