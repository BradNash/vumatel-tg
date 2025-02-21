# For more information on the repository see below.
# https://github.com/cloudposse/terraform-aws-ecs-alb-service-task

locals {
  container_name   = "supergraph"
  container_port   = 8080
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

inputs = {
  name                 = local.container_name
  container_port       = local.container_port
  ecs_cluster_arn      = dependency.cluster.outputs.arn
  dns_namespace_id     = dependency.cluster.outputs.dns_namespace_id
  alb_security_group      = dependency.alb.outputs.security_group_id
  health_status_code   = 200
  listener_host_header = "app-${local.environment_vars.locals.environment}"
  use_alb_security_group = true
  ecs_load_balancers = [
    {
      container_name   = local.container_name
      container_port   = local.container_port
      target_group_arn = null
      target_group_index = local.container_name
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
        path              = "/manage/health"
        port              = local.container_port
        timeout           = 30
        matcher           = 200
      }
      listener_arn          = dependency.alb.outputs.https_listener_arn
      listener_host_header  = "app-${local.environment_vars.locals.environment}"
      service_parent_domain = local.account_vars.locals.vumatel_dns
    },
  }
}
