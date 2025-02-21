# For more information on the repository see below.
# https://github.com/cloudposse/terraform-aws-nlb

locals {
  base_source_url  = "git::https://github.com/cloudposse/terraform-aws-nlb?ref=0.18.0"
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl", "account.hcl"))
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl", "region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl", "environment.hcl"))
}

dependency "vpc" {
  config_path = "${dirname(get_original_terragrunt_dir())}/../data/vpc"
}

inputs = {
    name= "${local.account_vars.locals.aws_account_id}-nlb-external"
    vpc_id= dependency.vpc.outputs.vpc_id
    subnet_ids= dependency.vpc.outputs.public_az_subnet_ids
    internal= false
    tcp_enabled= true
    security_group_enabled= true
    access_logs_enabled= true
    cross_zone_load_balancing_enabled= false
    health_check_enabled= false
    target_group_target_type= "ip"
    target_group_ip_address_type= "ipv4"
    health_check_enabled= true
    health_check_protocol= "TCP"
    health_check_threshold= 3
    health_check_unhealthy_threshold= 3
    health_check_timeout= 10
    health_check_interval= 30

    #default values
    # security_group_ids= []
    # subnet_mapping_enabled= false
    # tls_port= 443
    # tls_enabled= false
    # udp_port= 53
    # udp_enabled= false
    # eip_allocation_ids= []
    # slow_start= 0
    # target_group_additional_tags= {}
    # eip_additional_tags= {}
    # target_group_proxy_protocol_v2= false
    # target_group_preserve_client_ip= false
    # certificate_arn= ""
    # additional_certs= []
      default_listener_ingress_cidr_blocks= ["169.1.91.54/32"] # Only allow staff ips
    # default_listener_ingress_prefix_list_ids= []
    # tls_ingress_cidr_blocks= ["0.0.0.0/0"]
    # tls_ingress_prefix_list_ids= []
    # tls_ssl_policy= "ELBSecurityPolicy-2016-08"
    # allow_ssl_requests_only= false
    # access_logs_s3_bucket_id= null
    # ip_address_type= "ipv4"
    # deletion_protection_enabled= false
    # deregistration_delay= 15
    # nlb_access_logs_s3_bucket_force_destroy= false
    # lifecycle_configuration_rules= []
    # enforce_security_group_inbound_rules_on_private_link_traffic= null
}
