data "aws_iam_policy" "readonly_access" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_service_discovery_private_dns_namespace" "default" {
  name        = var.dns_namespace_name
  description = "Internal DNS for ecs service"
  vpc         = var.vpc_id
  tags = var.tags
}

resource "aws_sns_topic" "default" {
  count        = var.enable_slack_notifications ? 1 : 0
  name         = "${replace(module.this.id, ".", "-")}-topic"
  display_name = "${replace(module.this.id, ".", "-")}-topic"
  tags         = var.tags
}

resource "aws_iam_role" "chatbot_role" {
  count = var.enable_slack_notifications ? 1 : 0
  name  = "${replace(module.this.id, ".", "-")}-chatbot-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "chatbot.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = var.tags
}

# Attach CloudWatchReadOnlyAccess policy
resource "aws_iam_role_policy_attachment" "cloudwatch_read_only" {
  count      = var.enable_slack_notifications ? 1 : 0
  role       = aws_iam_role.chatbot_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

# Attach AWSResourceExplorerReadOnlyAccess policy
resource "aws_iam_role_policy_attachment" "resource_explorer_read_only" {
  count      = var.enable_slack_notifications ? 1 : 0
  role       = aws_iam_role.chatbot_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AWSResourceExplorerReadOnlyAccess"
}

resource "aws_chatbot_slack_channel_configuration" "default" {
  count              = var.enable_slack_notifications ? 1 : 0
  configuration_name = "${replace(module.this.id, ".", "-")}-channel"
  iam_role_arn       = aws_iam_role.chatbot_role[0].arn
  slack_channel_id   = var.slack_channel_id
  slack_team_id      = var.slack_team_id
  guardrail_policy_arns = [data.aws_iam_policy.readonly_access.arn]
  sns_topic_arns = [aws_sns_topic.default[0].arn]
  tags               = var.tags
}

resource "aws_cloudwatch_event_rule" "default" {
  count = var.enable_slack_notifications ? 1 : 0
  name  = "${replace(module.this.id, ".", "-")}-ecs-deployment-events"
  description = "${replace(module.this.id, ".", "-")}-deployment-events"
  # event_bus_name = "${replace(module.this.id, ".", "-")}-deployment-bus"
  event_pattern = jsonencode({
    source = ["aws.ecs"],
    "detail-type" : ["ECS Task State Change", "ECS Container Instance State Change", "ECS Deployment State Change"],
    detail = {
      clusterArn = aws_ecs_cluster.default[*].arn
    }
  })
  tags = var.tags
}

resource "aws_cloudwatch_event_target" "sns" {
  arn       = aws_sns_topic.default[0].arn
  rule      = aws_cloudwatch_event_rule.default[0].name
  target_id = "SendToSNS"
}

variable "dns_namespace_name" {
  type        = string
  description = "Name of the DNS namespace"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID where resources are created"
}

variable "enable_slack_notifications" {
  type        = bool
  default     = false
  description = "Enable Slack Notifications"
}

variable "slack_channel_id" {
  type        = string
  description = "Slack Channel ID"
}

variable "slack_team_id" {
  type        = string
  description = "Slack Team ID"
}

output "dns_namespace_name" {
  value       = aws_service_discovery_private_dns_namespace.default.name
  description = "Service discovery namespace name"
}

output "dns_namespace_arn" {
  value       = aws_service_discovery_private_dns_namespace.default.arn
  description = "Service discovery namespace arn"
}

output "dns_namespace_id" {
  value       = aws_service_discovery_private_dns_namespace.default.id
  description = "Service discovery namespace id"
}

output "aws_sns_topic_id" {
  value       = aws_sns_topic.default[0].id
  description = "SNS Topic id"
}

output "aws_sns_topic_arn" {
  value       = aws_sns_topic.default[0].arn
  description = "SNS Topic arn"
}

output "chat_configuration_arn" {
  value       = aws_chatbot_slack_channel_configuration.default[0].chat_configuration_arn
  description = "Service discovery namespace id"
}

output "slack_channel_name" {
  value       = aws_chatbot_slack_channel_configuration.default[0].slack_channel_name
  description = "SNS Topic id"
}

output "slack_team_name" {
  value       = aws_chatbot_slack_channel_configuration.default[0].slack_team_name
  description = "SNS Topic arn"
}

output "aws_event_id" {
  value       = aws_cloudwatch_event_rule.default[0].id
  description = "SNS Topic id"
}

output "aws_event_arn" {
  value       = aws_cloudwatch_event_rule.default[0].arn
  description = "SNS Topic arn"
}



