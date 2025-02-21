# For more information on the repository see below.
# https://github.com/cloudposse/terraform-aws-dynamodb

locals {
  base_source_url = "${get_repo_root()}/terraform-modules/modules/vumatel/terraform-aws-batch-compute-environment"
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl", "account.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl", "region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl", "environment.hcl"))
}

dependency "vpc" {
  config_path = "${dirname(get_original_terragrunt_dir())}/../../data/vpc"
}

inputs = {
  # COMPUTE ENVIRONMENT
  type                            = "MANAGED"
  state                           = "ENABLED"
  vpc_id                          = dependency.vpc.outputs.vpc_id
  compute_environment_name_prefix = null
  service_role                    = ""
  compute_resources = {
    subnets             = dependency.vpc.outputs.private_az_subnet_ids
    security_group_ids = []
    allocation_strategy = null
    bid_percentage      = 0
    desired_vcpus       = 0
    ec2_configuration = []
    ec2_key_pair        = ""
    instance_role       = ""
    instance_type = []
    launch_template     = null
    max_vcpus           = 16
    min_vcpus           = 0
    placement_group     = ""
    spot_iam_fleet_role = ""
    type                = "FARGATE"
  }
  update_policy = {
    job_execution_timeout_minutes = 30
    terminate_jobs_on_update      = false
  }
  eks_configuration = {
    eks_cluster_arn      = ""
    kubernetes_namespace = ""
  }
  security_group_ingress_rules = [
    {
      from_port       = 0
      to_port         = 0
      protocol        = "tcp"
      description     = "Allow ingress from vpc"
      cidr_blocks = [dependency.vpc.outputs.vpc_cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = null
      self            = false
    }
  ]
}
