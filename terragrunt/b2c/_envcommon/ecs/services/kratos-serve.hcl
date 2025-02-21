# For more information on the repository see below.
# https://github.com/cloudposse/terraform-aws-ecs-alb-service-task

locals {
  container_name   = "kratos-serve"
  container_port   = 4433
  admin_port = 4434
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl", "account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl", "environment.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl", "region.hcl"))
}

dependency "cluster" {
  config_path = "${dirname(get_original_terragrunt_dir())}/../../../shared/ecs/b2c-cluster"
}

dependency "alb" {
  config_path = "${dirname(get_original_terragrunt_dir())}/../../../shared/network/b2c-alb"
}

dependency "alb_internal" {
  config_path = "${dirname(get_original_terragrunt_dir())}/../../../shared/network/b2c-alb-internal"
}

inputs = {
  name                    = local.container_name
  container_port          = local.container_port
  alb_listener_arn        = dependency.alb.outputs.https_listener_arn
  ecs_cluster_arn         = dependency.cluster.outputs.arn
  dns_namespace_id        = dependency.cluster.outputs.dns_namespace_id
  alb_security_group      = dependency.alb.outputs.security_group_id
  alb_internal_security_group = dependency.alb_internal.outputs.security_group_id
  task_cpu                = 512
  task_memory             = 1024
  health_check_path       = "/health/ready"
  health_protocol         = "HTTP"
  health_status_code      = 200
  enable_service_registry = true
  service_registries      = []
  use_custom_alb_security_group  = true


  # TODO: Refactor the ingress setup, this looks horrible
  ecs_load_balancers      = [
    {
      container_name   = local.container_name
      container_port   = local.container_port
      target_group_arn = null
      target_group_index = local.container_name
    },
    {
      container_name   = local.container_name
      container_port   = local.admin_port
      target_group_arn = null
      target_group_index = "${local.container_name}-admin"
    }
  ]
  ingress = {
    "${local.container_name}" = { 
      is_internal         = false
      port                = local.container_port
      health_check        = {
        enabled           = true
        healthy_threshold = 3 
        interval          = 60
        path              = "/health/ready"
        port              = local.container_port
        timeout           = 30
        matcher           = 200
      }
      listener_arn          = dependency.alb.outputs.https_listener_arn
      listener_host_header  = "auth-${local.environment_vars.locals.environment}"
      service_parent_domain = local.account_vars.locals.vumatel_dns
    }
    "${local.container_name}-admin" = {
      is_internal         = true
      port                = local.admin_port
      health_check        = {
        enabled           = true
        healthy_threshold = 3 
        interval          = 60
        path              = "/admin/health/ready"
        port              = local.admin_port
        timeout           = 30
        matcher           = 200
      }
      listener_arn          = dependency.alb_internal.outputs.https_listener_arn
      listener_host_header  = "auth-${local.environment_vars.locals.environment}"
      service_parent_domain = local.account_vars.locals.vumatel_dns
    }
  }
}
