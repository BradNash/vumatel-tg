# For more information on the repository see below.
# https://github.com/cloudposse/terraform-aws-ecs-alb-service-task

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl", "account.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl", "environment.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl", "region.hcl"))
}

dependency "cluster" {
  config_path = "${dirname(get_original_terragrunt_dir())}/../../../shared/ecs/b2c-cluster"
}

inputs = {
  name                        = "kratos-courier"
  container_port              = 8443
  ecs_cluster_arn             = dependency.cluster.outputs.arn
  dns_namespace_id            = dependency.cluster.outputs.dns_namespace_id
  task_cpu                    = 512
  task_memory                 = 1024
  register_with_load_balancer = false
  enable_service_registry     = true
  use_alb_security_group      = false
}
