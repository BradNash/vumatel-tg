data "aws_region" "region" {}

resource "aws_cloudwatch_event_rule" "batch_scheduling_rule" {
  count               = var.enable_cron_scheduling ? 1 : 0
  name                = "${var.name}-batch-${var.environment}-schedule"
  description         = "Schedule ${var.name}-${var.environment} batch job"
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "aws_batch_target" {
  count     = var.enable_cron_scheduling ? 1 : 0
  rule      = aws_cloudwatch_event_rule.batch_scheduling_rule[0].name
  target_id = "ScheduleAWSBatchJob"
  arn       = var.batch_queue_arn
  role_arn  = var.execution_role_arn
  batch_target {
    job_name       = "${var.name}-batch-${var.environment}"
    job_definition = aws_batch_job_definition.default.arn
  }
}

resource "aws_batch_job_definition" "default" {
  name                       = module.this.id
  type                       = var.type
  platform_capabilities      = var.platform_capabilities
  tags                       = var.tags
  deregister_on_new_revision = false
  container_properties = jsonencode({
    entrypoint = ["echo", "Dummy container running"]
    image = var.image_url
    fargatePlatformConfiguration = {
      platformVersion = "LATEST"
    }
    resourceRequirements = [
      {
        type  = "VCPU"
        value = "0.25"
      },
      {
        type  = "MEMORY"
        value = "512"
      }
    ]
    executionRoleArn = var.execution_role_arn
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/service/${module.this.id}"
        awslogs-region        = data.aws_region.region.name
        awslogs-stream-prefix = "service"
      }
    }
  })

  lifecycle {
    ignore_changes = all
  }
}
