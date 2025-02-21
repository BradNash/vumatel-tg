# For more information on the repository see below.
# https://github.com/cloudposse/terraform-aws-ecs-alb-service-task

locals {
  base_source_url  = "${get_repo_root()}/terraform-modules/modules/cloudposse/terraform-aws-ecs-alb-service-task"
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl", "account.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl", "region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl", "environment.hcl"))
}

dependency "vpc" {
  config_path = "${dirname(get_original_terragrunt_dir())}/../../data/vpc"
}

dependency "ssa_ecs_task_tg" {
  config_path = "${dirname(get_original_terragrunt_dir())}/../../network/security-groups/ssa-ecs-task-sg"
}

inputs = {
  vpc_id                             = dependency.vpc.outputs.vpc_id
  subnet_ids                         = tolist(dependency.vpc.outputs.private_az_subnet_ids)
  dns_record_ttl                     = 10
  dns_record_type                    = "A"
  dns_routing_policy                 = "MULTIVALUE"
  dns_failure_threshold              = 1
  launch_type                        = "FARGATE"
  propagate_tags                     = "TASK_DEFINITION"
  deployment_controller_type         = "ECS"
  desired_count                      = 1
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  health_check_grace_period_seconds  = 60
  task_cpu                           = 256
  task_memory                        = 512
  ignore_changes_task_definition     = true
  exec_enabled                       = true
  enable_all_egress_rule             = true
  assign_public_ip                   = false
  wait_for_steady_state              = true
  force_new_deployment               = true
  redeploy_on_apply                  = false
  ecs_service_enabled                = true
  role_tags_enabled                  = false
  container_definition_json          = null
  security_group_enabled             = true
  security_group_description         = "Allow ALL egress from ECS service"
  network_mode                       = "awsvpc"
  service_type                       = "Service"

  # Ingress, Health Checks & Target Group
  use_alb_security_group             = false
  load_balancer_path                 = "/*"
  ingress                            = {}
  capacity_provider_strategies   = [
    {
      capacity_provider = "FARGATE_SPOT"
      weight            = 100
      base              = 1
    }
  ]
  task_exec_policy_arns = ["arn:aws:iam::aws:policy/SecretsManagerReadWrite"]
  task_policy_arns      = ["arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess", "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"]
  security_group_ids    = [dependency.ssa_ecs_task_tg.outputs.id]

  #   platform_version                   = "LATEST"
  #   scheduling_strategy                = "REPLICA"
  #   enable_ecs_managed_tags            = false
  #   enable_icmp_rule                   = false
  #   use_nlb_cidr_blocks                = false
  #   nlb_container_port                 = 80
  #   nlb_cidr_blocks                    = []
  #   ordered_placement_strategy         = []
  #   task_placement_constraints         = []
  #   service_placement_constraints      = []
  #   task_exec_role_arn = []
  #   task_exec_policy_arns_map = {}
  #   task_role_arn    = []
  #   task_policy_arns_map = {}
  #   service_role_arn                   = null
  #   runtime_platform                   = []
  #   efs_volumes                        = []
  #   bind_mount_volumes                 = []
  #   docker_volumes                     = []
  #   fsx_volumes                        = []
  #   service_registries                 = []
  #   proxy_configuration                = null
  #   ignore_changes_desired_count       = false
  #   service_connect_configurations     = []
  #   permissions_boundary               = ""
  #   use_old_arn                        = false
  #   redeploy_on_apply                  = false
  #   circuit_breaker_deployment_enabled = false
  #   circuit_breaker_rollback_enabled   = false
  #   ephemeral_storage_size             = 0
  #   ipc_mode                           = null
  #   pid_mode                           = null
  #   task_definition        = []

}
