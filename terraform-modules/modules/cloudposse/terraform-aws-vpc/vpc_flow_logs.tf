resource "aws_flow_log" "this" {
  count = var.enable_flow_log ? 1 : 0

  log_destination_type     = "cloud-watch-logs"
  log_destination          = aws_cloudwatch_log_group.this[0].arn
  iam_role_arn             = aws_iam_role.this[0].arn
  traffic_type             = var.flow_log_traffic_type
  vpc_id                   = module.vpc_base.vpc_id
  max_aggregation_interval = var.flow_log_max_aggregation_interval

  tags = merge(
    module.this.tags,
    { Name = join(module.this.delimiter, [module.this.id_full, "flow", "log"]) }
  )
}

resource "aws_cloudwatch_log_group" "this" {
  count = var.enable_flow_log ? 1 : 0

  name              = join(module.this.delimiter, ["/aws/vpc-flow-log/${module.this.id_full}", "flow", "log", "group", module.vpc_base.vpc_id])
  retention_in_days = var.flow_log_cloudwatch_log_group_retention

  tags = merge(
    module.this.tags,
    { Name = join(module.this.delimiter, [module.this.id_full, "flow", "log", "group"]) },
  )
}

resource "aws_iam_role" "this" {
  count = var.enable_flow_log ? 1 : 0

  name = join(module.this.delimiter, [replace(module.this.id_full, module.this.name, "role"), "vpc","flow", "log", ])

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSvpcFlowLogsAssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })

  tags = merge(
    module.this.tags,
    { Name = join(module.this.delimiter, [replace(module.this.id_full, module.this.name, "role"), "vpc", "flow", "log"]) },
  )
}

resource "aws_iam_role_policy_attachment" "this" {
  count = var.enable_flow_log ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.this[0].arn
}

resource "aws_iam_policy" "this" {
  count = var.enable_flow_log ? 1 : 0

  name_prefix = join(module.this.delimiter, [replace(module.this.id_full, module.this.name, "policy"), "vpc", "flow", "log"])

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AWSVPCFlowLogsPushToCloudWatch"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })

  tags = merge(
    module.this.tags,
    { Name = join(module.this.delimiter, [replace(module.this.id_full, module.this.name, "policy"), "vpc", "flow", "log", ]) },
  )
}