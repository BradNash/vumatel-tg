resource "aws_security_group" "default" {
  name                   = "${module.this.id}-sg"
  description            = "Security Group for Batch Compute Environment"
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = false
  tags = merge(module.this.tags, { Name = "${module.this.id}-sg" })

  lifecycle {
    create_before_destroy = false
  }

  dynamic "ingress" {
    for_each = var.security_group_ingress_rules
    content {
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      description      = ingress.value.description
      cidr_blocks      = ingress.value.cidr_blocks
      ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks
      prefix_list_ids  = ingress.value.prefix_list_ids
      security_groups  = ingress.value.security_groups
      self             = ingress.value.self
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol = "-1"  # Allow all protocols
    description = "Allow all egress traffic"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids = []
    security_groups = []
    self        = false
  }

}

resource "aws_iam_role" "aws_batch_service_role" {
  name = "batch-service-role-${module.this.id}"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "batch.amazonaws.com"
        }
    }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "aws_batch_service_role" {
  role       = aws_iam_role.aws_batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}


resource "aws_batch_compute_environment" "default" {
  compute_environment_name        = module.this.id
  compute_environment_name_prefix = var.compute_environment_name_prefix
  type = var.type
  # state                           = var.state
  service_role                    = var.service_role != "" ? var.service_role : aws_iam_role.aws_batch_service_role.arn
  tags                            = var.tags

  compute_resources {
    max_vcpus = var.compute_resources.max_vcpus
    min_vcpus = var.compute_resources.min_vcpus
    security_group_ids = concat(var.compute_resources.security_group_ids, [aws_security_group.default.id])
    subnets   = var.compute_resources.subnets
    type      = var.compute_resources.type
    # allocation_strategy = var.compute_resources.allocation_strategy
    # bid_percentage      = var.compute_resources.bid_percentage
    # desired_vcpus       = var.compute_resources.desired_vcpus
    # ec2_key_pair        = var.compute_resources.ec2_key_pair
    # instance_role       = var.compute_resources.instance_role
    # instance_type       = var.compute_resources.instance_type
    # placement_group     = var.compute_resources.placement_group
    # spot_iam_fleet_role = var.compute_resources.spot_iam_fleet_role
    #   dynamic "ec2_configuration" {
    #     for_each = var.compute_resources.ec2_configuration != null && length(var.compute_resources.ec2_configuration) > 0 ? var.compute_resources.ec2_configuration : []
    #     content {
    #       image_id_override = ec2_configuration.value.image_id_override
    #       image_type        = ec2_configuration.value.image_type
    #     }
    #   }
    #
    #   dynamic "launch_template" {
    #     for_each = var.compute_resources.launch_template != null ? [var.compute_resources.launch_template] : []
    #     content {
    #       launch_template_id   = launch_template.value.launch_template_id
    #       launch_template_name = launch_template.value.launch_template_name
    #       version              = launch_template.value.version
    #     }
    #   }
  }

  # dynamic "eks_configuration" {
  #   for_each = var.eks_configuration != null && var.eks_configuration.eks_cluster_arn != "" ? [var.eks_configuration] : []
  #   content {
  #     eks_cluster_arn      = eks_configuration.value.eks_cluster_arn
  #     kubernetes_namespace = eks_configuration.value.kubernetes_namespace
  #   }
  # }

  # update_policy {
  #   job_execution_timeout_minutes = var.update_policy.job_execution_timeout_minutes
  #   terminate_jobs_on_update      = var.update_policy.terminate_jobs_on_update
  # }
}

resource "aws_batch_job_queue" "default" {
  name     = module.this.id
  priority = 1
  state    = var.state
  tags     = var.tags
  compute_environments = [
    aws_batch_compute_environment.default.arn,
  ]
}

