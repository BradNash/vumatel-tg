variable "compute_environment_name_prefix" {
  description = "Prefix for a unique compute environment name. Conflicts with compute_environment_name."
  type        = string
  default     = ""
}

variable "type" {
  description = "The type of the compute environment (MANAGED or UNMANAGED)."
  type        = string
  default     = "MANAGED"
}

variable "state" {
  description = "The state of the compute environment (ENABLED or DISABLED)."
  type        = string
  default     = "ENABLED"
}

variable "service_role" {
  description = "The IAM role ARN that allows AWS Batch to make calls to other AWS services."
  type        = string
  default     = ""
}

# Compute resources variable definition
variable "compute_resources" {
  description = "Consolidated compute resource configuration"
  type = object({
    allocation_strategy = string
    bid_percentage      = number
    desired_vcpus       = number
    ec2_configuration = list(object({
      image_id_override = string
      image_type        = string
    }))
    ec2_key_pair  = string
    instance_role = string
    instance_type = list(string)
    launch_template = object({
      launch_template_id   = string
      launch_template_name = string
      version              = string
    })
    max_vcpus           = number
    min_vcpus           = number
    placement_group     = string
    security_group_ids = list(string)
    spot_iam_fleet_role = string
    subnets = list(string)
    type                = string
  })
  default = {
    allocation_strategy = null
    bid_percentage      = 0
    desired_vcpus       = 0
    ec2_configuration = []
    ec2_key_pair        = ""
    instance_role       = ""
    instance_type = []
    launch_template     = null
    max_vcpus           = 0
    min_vcpus           = 0
    placement_group     = ""
    security_group_ids = []
    spot_iam_fleet_role = ""
    subnets = []
    type                = ""
  }
}

# EKS configuration variable definition
variable "eks_configuration" {
  description = "EKS cluster configuration"
  type = object({
    eks_cluster_arn      = string
    kubernetes_namespace = string
  })
  default = {
    eks_cluster_arn      = ""
    kubernetes_namespace = ""
  }
}

# Update policy variable definition
variable "update_policy" {
  description = "Update policy for compute environment"
  type = object({
    job_execution_timeout_minutes = number
    terminate_jobs_on_update      = bool
  })
  default = {
    job_execution_timeout_minutes = 30
    terminate_jobs_on_update      = false
  }
}


variable "security_group_ingress_rules" {
  description = "Consolidated compute resource configuration"
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    description      = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    prefix_list_ids  = list(string)
    security_groups  = list(string)
    self             = bool
  }))

  default = []
}

variable "vpc_id" {
  type = string
  description = "VPC ID"
}


