data "aws_region" "region" {}

resource "aws_alb_target_group" "fargate_alb_target_group" {
  for_each                      = { for i, v in var.ingress : i => v }
  name                          = "${each.key}-tg"
  port                          = each.value.port
  protocol                      = each.value.protocol
  vpc_id                        = var.vpc_id
  target_type                   = each.value.target_type
  load_balancing_algorithm_type = each.value.load_balancing_algorithm_type

  health_check {
    enabled           = each.value.health_check.enabled
    healthy_threshold = each.value.health_check.healthy_threshold
    interval          = each.value.health_check.interval
    path              = each.value.health_check.path
    port              = each.value.health_check.port
    timeout           = each.value.health_check.timeout
    matcher           = each.value.health_check.matcher
    protocol          = each.value.health_check.protocol
  }

  tags = module.this.tags
}

resource "aws_lb_listener_rule" "alb_rule" {
  for_each     = { for i, v in var.ingress : i => v }
  listener_arn = each.value.listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.fargate_alb_target_group[each.key].arn
  }

  condition {
    path_pattern {
      values = [each.value.listener_path]
    }
  }

  condition {
    host_header {
      values = ["${chomp(each.value.listener_host_header)}.${chomp(each.value.service_parent_domain)}"]
    }
  }
  tags = module.this.tags
}

resource "aws_security_group_rule" "additional_sg_rules_internal" {
  for_each     = { for i, v in var.ingress : i => v if local.create_security_group && var.use_custom_alb_security_group && v.is_internal }
  description              = "Allow inbound traffic from ALB for ${each.key}"
  type                     = "ingress"
  from_port                = each.value.port
  to_port                  = each.value.port
  protocol                 = "tcp"
  source_security_group_id = var.alb_internal_security_group 
  security_group_id        = one(aws_security_group.ecs_service[*]["id"])
}

resource "aws_security_group_rule" "additional_sg_rules_external" {
  for_each     = { for i, v in var.ingress : i => v if local.create_security_group && var.use_custom_alb_security_group && !v.is_internal }
  description              = "Allow inbound traffic from ALB for ${each.key}"
  type                     = "ingress"
  from_port                = each.value.port
  to_port                  = each.value.port
  protocol                 = "tcp"
  source_security_group_id = var.alb_security_group
  security_group_id        = one(aws_security_group.ecs_service[*]["id"])
}

resource "aws_cloudwatch_log_group" "service_cloudwatch_log_group" {
  name = "/service/${module.this.id}"
}

module "dummy_container_definition" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.58.1"

  log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = aws_cloudwatch_log_group.service_cloudwatch_log_group.name
      awslogs-region        = data.aws_region.region.name
      awslogs-stream-prefix = var.environment
    }
  }
  container_image = "992382552351.dkr.ecr.af-south-1.amazonaws.com/shared/ealen/echo-server"
  container_name  = var.name
  port_mappings = [
    {
      containerPort = var.container_port
      hostPort      = var.container_port
      protocol      = "tcp"
    }
  ]
  environment = [
    {
      name  = "PORT"
      value = var.container_port != null ? var.container_port : var.container_port
    },
  ]
}

resource "aws_service_discovery_service" "default" {
  name = var.name

  dns_config {
    namespace_id   = var.dns_namespace_id
    routing_policy = var.dns_routing_policy

    dns_records {
      ttl  = var.dns_record_ttl
      type = var.dns_record_type
    }
  }

  health_check_custom_config {
    failure_threshold = var.dns_failure_threshold
  }
}

resource "aws_ssm_parameter" "ssm_parameter" {
  name        = "${module.this.id}-config"
  description = "Service config for ${module.this.id}"
  type        = "SecureString"
  tier        = "Standard"
  value       = "DUMMY"

  lifecycle {
    ignore_changes = [value]
  }
}

##########################
## VARIABLES
##########################

variable "service_type" {
  description = "Type of service. Must be one of: SERVICE, NODE, BATCH-JOB."
  type        = string
  default     = "SERVICE"

  validation {
    condition     = contains(["Service", "Node", "Batch-Job"], var.service_type)
    error_message = "The service_type variable must be one of: SERVICE, NODE, BATCH-JOB."
  }
}
variable "enable_service_registry" {
  description = "Whether to enable service registry or not"
  type        = bool
  default     = false
}

variable "use_custom_alb_security_group" {
  type        = bool
  description = "A flag to enable/disable allowing traffic from the ALB security group to the service security group"
  default     = false
}

variable "alb_internal_security_group" {
  type        = string
  description = "Security group of the ALB"
  default     = ""
}

variable "dns_record_ttl" {
  type        = number
  description = "Time to live for dns records"
  default     = 10
}

variable "dns_record_type" {
  type        = string
  description = "Type for dns records"
  default     = "A"
}

variable "dns_routing_policy" {
  type        = string
  description = "DNS routing policy"
  default     = "MULTIVALUE"
}

variable "dns_failure_threshold" {
  type        = number
  description = "DNS failure threshold"
  default     = 1
}

variable "dns_namespace_id" {
  type        = string
  description = "DNS namespace id"
}

variable "ingress" {
  type = map(object({
    is_internal                   = bool
    port                          = number
    protocol                      = optional(string, "HTTP")
    target_type                   = optional(string, "ip")
    load_balancing_algorithm_type = optional(string, "round_robin")
    health_check = object({
      enabled           = bool
      healthy_threshold = number
      interval          = number
      path              = string
      port              = number
      timeout           = number
      matcher           = string
      protocol          = optional(string, "HTTP")
    })
    listener_arn          = string
    listener_path         = optional(string, "/*")
    listener_host_header  = string
    service_parent_domain = string
  }))
  default = {}
}

##########################
## OUTPUTS
##########################

output "service_discovery_arn" {
  value       = aws_service_discovery_service.default.arn
  description = "Service discovery arn"
}
