variable "vpc_cidr_block" {
  type = string
}

variable "public_nat_gateway_enabled" {
  type    = bool
  default = false
}

variable "s3_gateway_endpoint_enabled" {
  description = "Enable VPC Gateway Endpoint for Amazon S3"
  type        = bool
  default     = false
}

variable "transit_gateway_enabled" {
  type    = bool
  default = false
}

variable "is_external_account" {
  type    = bool
  default = false
}

variable "transit_gateway_id" {
  type    = string
  default = null
}

variable "internet_gateway_enabled" {
  type        = bool
  description = "A boolean flag to enable/disable Internet Gateway creation"
  default     = false
}

variable "create_tgw_attachment" {
  type    = bool
  default = false
}

variable "subnet_azs" {
  type = list(string)
}

variable "public_subnets_cidr_block" {
  type    = string
  default = ""
}

variable "private_subnets_cidr_block" {
  type    = string
  default = ""
}

variable "isolated_subnets_cidr_block" {
  type    = string
  default = ""
}

variable "semi_isolated_routed_subnets" {
  type        = list(string)
  default     = []
  description = "List of CIDR Blocks that will be added to the isolated subnet route tables"
}

variable "public_subnets_network_acl_ingress" {
  type    = list(map(string))
  default = []
}

variable "public_subnets_network_acl_egress" {
  type    = list(map(string))
  default = []
}

variable "private_subnets_network_acl_ingress" {
  type    = list(map(string))
  default = []
}

variable "private_subnets_network_acl_egress" {
  type    = list(map(string))
  default = []
}

variable "tgw_subnets_network_acl_ingress" {
  type    = list(map(string))
  default = []
}

variable "tgw_subnets_network_acl_egress" {
  type    = list(map(string))
  default = []
}

variable "tgw_subnets_cidr_block" {
  type    = string
  default = ""
}

variable "tgw_vpc_attachment_appliance_mode_support" {
  type        = string
  default     = "disable"
  description = "Whether Appliance Mode support is enabled. If enabled, a traffic flow between a source and destination uses the same Availability Zone for the VPC attachment for the lifetime of that flow. Valid values: `disable`, `enable`"
}

variable "tgw_vpc_attachment_dns_support" {
  type        = string
  default     = "enable"
  description = "Whether resource attachments automatically propagate routes to the default propagation route table. Valid values: `disable`, `enable`. Default value: `enable`"
}

variable "tgw_vpc_attachment_ipv6_support" {
  type        = string
  default     = "disable"
  description = "Whether resource attachments automatically propagate routes to the default propagation route table. Valid values: `disable`, `enable`. Default value: `disable`"
}

variable "private_zone_name" {
  type     = string
  default  = ""
  nullable = true
}

variable "resolver_rule_ids" {
  type        = set(string)
  default     = []
  description = "List of Route 53 Resolver rule ID's to associate with the VPC."
}

variable "public_subnet_tags" {
  type    = map(string)
  default = {}
}

variable "private_subnet_tags" {
  type    = map(string)
  default = {}
}

variable "default_security_group_deny_all" {
  type        = bool
  default     = false
  description = <<-EOT
    When `true`, manage the default security group and remove all rules, disabling all ingress and egress.
    When `false`, do not manage the default security group, allowing it to be managed by another component.
    EOT
}

variable "default_route_table_no_routes" {
  type        = bool
  default     = true
  description = <<-EOT
    When `true`, manage the default route table and remove all routes, disabling all ingress and egress.
    When `false`, do not mange the default route table, allowing it to be managed by another component.
    Conflicts with Terraform resource `aws_main_route_table_association`.
    EOT
}

variable "default_network_acl_deny_all" {
  type        = bool
  default     = true
  description = <<-EOT
    When `true`, manage the default network acl and remove all rules, disabling all ingress and egress.
    When `false`, do not mange the default networking acl, allowing it to be managed by another component.
    EOT
}

variable "enable_flow_log" {
  description = "Whether or not to enable VPC Flow Logs"
  type        = bool
  default     = false
}

variable "flow_log_traffic_type" {
  description = "The type of traffic to capture. Valid values: ACCEPT, REJECT, ALL"
  type        = string
  default     = "ALL"
  validation {
    error_message = "Valid values are ACCEPT, REJECT, ALL."
    condition     = contains(["ACCEPT", "REJECT", "ALL"], var.flow_log_traffic_type)
  }
}

variable "flow_log_max_aggregation_interval" {
  description = "The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record. Valid Values: `60` or `600` seconds"
  type        = number
  default     = 600
}

variable "flow_log_cloudwatch_log_group_retention" {
  description = "Specifies the number of days you want to retain log events in the specified log group for VPC flow logs"
  type        = number
  default     = 90
}

