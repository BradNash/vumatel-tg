# AWS Multi-Layer VPC
*This module creates a CIS WAF based VPC with support for Transit Gateways, NAT Gateways, Private Hosted Zones,
*multiple subnets (Public, Private, Isolated, TGW), automatic subnet division for multi-AZ setups and
*Organization based RAM Resource Sharing for the TGW.

*If `public_nat_gateway_enabled` variable is set to `true`, the module will provision NAT Gateways across all provided
*Availability Zones within the Public Subnets.

*If `create_tgw_attachment` variable is set to `true`, the module will provision a Transit Gateway Resource attachment.
*In this case `transit_gateway_id` becomes mandatory and needs to be given the id value of the pre-existing Transit Gateway.

*If `private_zone_name` variable is given a value, the module will provision a Private Hosted Zone for the VPC.

## Usage

Terragrunt sample input

```hcl
inputs = {
  vpc_name                    = "Shared-VPC"
  s3_gateway_endpoint_enabled = true
  vpc_cidr_block              = "172.28.24.0/21"
  public_subnets_cidr_block   = "172.28.24.0/23"
  private_subnets_cidr_block  = "172.28.26.0/23"
  isolated_subnets_cidr_block = "172.28.28.0/23"
  tgw_subnets_cidr_block      = "172.28.30.0/27"
  public_nat_gateway_enabled  = false
  stage                       = "Shared"
  private_zone_name           = "shared.pvt.bbd-mserv.com"
  subnet_azs                  = ["af-south-1a", "af-south-1b"]
  create_tgw_attachment       = true
  transit_gateway_id          = "tgw-8138293qwerty"
  internet_gateway_enabled    = true
  is_external_account         = false
  public_subnet_tags          = { "kubernetes.io/role/elb" = "1" }
  private_subnet_tags         = { "kubernetes.io/role/internal-elb" = "1" }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_isolated_subnets"></a> [isolated\_subnets](#module\_isolated\_subnets) | cloudposse/multi-az-subnets/aws | 0.14.2 |
| <a name="module_private_subnets"></a> [private\_subnets](#module\_private\_subnets) | ./modules/aws-multi-az-subnets | n/a |
| <a name="module_public_subnets"></a> [public\_subnets](#module\_public\_subnets) | ./modules/aws-multi-az-subnets | n/a |
| <a name="module_semi_isolated_routes"></a> [semi\_isolated\_routes](#module\_semi\_isolated\_routes) | ./modules/aws-routes | n/a |
| <a name="module_tgw_subnets"></a> [tgw\_subnets](#module\_tgw\_subnets) | ./modules/aws-multi-az-subnets | n/a |
| <a name="module_vpc_base"></a> [vpc\_base](#module\_vpc\_base) | cloudposse/vpc/aws | 0.28.1 |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_transit_gateway.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_ram_principal_association.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_principal_association) | resource |
| [aws_ram_resource_association.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_ram_resource_share.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_share) | resource |
| [aws_route.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route53_resolver_rule_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_rule_association) | resource |
| [aws_route53_zone.PrivateZone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_vpc_endpoint.s3_gw_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_organizations_organization.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/organizations_organization) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_tgw_attachment"></a> [create\_tgw\_attachment](#input\_create\_tgw\_attachment) | n/a | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_internet_gateway_enabled"></a> [internet\_gateway\_enabled](#input\_internet\_gateway\_enabled) | A boolean flag to enable/disable Internet Gateway creation | `bool` | `false` | no |
| <a name="input_is_external_account"></a> [is\_external\_account](#input\_is\_external\_account) | n/a | `bool` | `false` | no |
| <a name="input_isolated_subnets_cidr_block"></a> [isolated\_subnets\_cidr\_block](#input\_isolated\_subnets\_cidr\_block) | n/a | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_private_subnet_tags"></a> [private\_subnet\_tags](#input\_private\_subnet\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_private_subnets_cidr_block"></a> [private\_subnets\_cidr\_block](#input\_private\_subnets\_cidr\_block) | n/a | `string` | `""` | no |
| <a name="input_private_subnets_network_acl_egress"></a> [private\_subnets\_network\_acl\_egress](#input\_private\_subnets\_network\_acl\_egress) | n/a | `list(map(string))` | `[]` | no |
| <a name="input_private_subnets_network_acl_ingress"></a> [private\_subnets\_network\_acl\_ingress](#input\_private\_subnets\_network\_acl\_ingress) | n/a | `list(map(string))` | `[]` | no |
| <a name="input_private_zone_name"></a> [private\_zone\_name](#input\_private\_zone\_name) | n/a | `string` | `""` | no |
| <a name="input_public_nat_gateway_enabled"></a> [public\_nat\_gateway\_enabled](#input\_public\_nat\_gateway\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_public_subnet_tags"></a> [public\_subnet\_tags](#input\_public\_subnet\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_public_subnets_cidr_block"></a> [public\_subnets\_cidr\_block](#input\_public\_subnets\_cidr\_block) | n/a | `string` | `""` | no |
| <a name="input_public_subnets_network_acl_egress"></a> [public\_subnets\_network\_acl\_egress](#input\_public\_subnets\_network\_acl\_egress) | n/a | `list(map(string))` | `[]` | no |
| <a name="input_public_subnets_network_acl_ingress"></a> [public\_subnets\_network\_acl\_ingress](#input\_public\_subnets\_network\_acl\_ingress) | n/a | `list(map(string))` | `[]` | no |
| <a name="input_resolver_rule_ids"></a> [resolver\_rule\_ids](#input\_resolver\_rule\_ids) | List of Route 53 Resolver rule ID's to associate with the VPC. | `set(string)` | `[]` | no |
| <a name="input_s3_gateway_endpoint_enabled"></a> [s3\_gateway\_endpoint\_enabled](#input\_s3\_gateway\_endpoint\_enabled) | Enable VPC Gateway Endpoint for Amazon S3 | `bool` | `false` | no |
| <a name="input_semi_isolated_routed_subnets"></a> [semi\_isolated\_routed\_subnets](#input\_semi\_isolated\_routed\_subnets) | List of CIDR Blocks that will be added to the isolated subnet route tables | `list(string)` | `[]` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_subnet_azs"></a> [subnet\_azs](#input\_subnet\_azs) | n/a | `list(string)` | n/a | yes |
| <a name="input_tags_base"></a> [tags\_base](#input\_tags\_base) | n/a | `map(string)` | n/a | yes |
| <a name="input_tgw_subnets_cidr_block"></a> [tgw\_subnets\_cidr\_block](#input\_tgw\_subnets\_cidr\_block) | n/a | `string` | `""` | no |
| <a name="input_tgw_subnets_network_acl_egress"></a> [tgw\_subnets\_network\_acl\_egress](#input\_tgw\_subnets\_network\_acl\_egress) | n/a | `list(map(string))` | `[]` | no |
| <a name="input_tgw_subnets_network_acl_ingress"></a> [tgw\_subnets\_network\_acl\_ingress](#input\_tgw\_subnets\_network\_acl\_ingress) | n/a | `list(map(string))` | `[]` | no |
| <a name="input_tgw_vpc_attachment_appliance_mode_support"></a> [tgw\_vpc\_attachment\_appliance\_mode\_support](#input\_tgw\_vpc\_attachment\_appliance\_mode\_support) | Whether Appliance Mode support is enabled. If enabled, a traffic flow between a source and destination uses the same Availability Zone for the VPC attachment for the lifetime of that flow. Valid values: `disable`, `enable` | `string` | `"disable"` | no |
| <a name="input_tgw_vpc_attachment_dns_support"></a> [tgw\_vpc\_attachment\_dns\_support](#input\_tgw\_vpc\_attachment\_dns\_support) | Whether resource attachments automatically propagate routes to the default propagation route table. Valid values: `disable`, `enable`. Default value: `enable` | `string` | `"enable"` | no |
| <a name="input_tgw_vpc_attachment_ipv6_support"></a> [tgw\_vpc\_attachment\_ipv6\_support](#input\_tgw\_vpc\_attachment\_ipv6\_support) | Whether resource attachments automatically propagate routes to the default propagation route table. Valid values: `disable`, `enable`. Default value: `disable` | `string` | `"disable"` | no |
| <a name="input_transit_gateway_enabled"></a> [transit\_gateway\_enabled](#input\_transit\_gateway\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_transit_gateway_id"></a> [transit\_gateway\_id](#input\_transit\_gateway\_id) | n/a | `string` | `null` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | n/a | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_igw_id"></a> [igw\_id](#output\_igw\_id) | n/a |
| <a name="output_isolated_az_ngw_ids"></a> [isolated\_az\_ngw\_ids](#output\_isolated\_az\_ngw\_ids) | n/a |
| <a name="output_isolated_az_route_table_ids"></a> [isolated\_az\_route\_table\_ids](#output\_isolated\_az\_route\_table\_ids) | n/a |
| <a name="output_isolated_az_subnet_arns"></a> [isolated\_az\_subnet\_arns](#output\_isolated\_az\_subnet\_arns) | n/a |
| <a name="output_isolated_az_subnet_cidr_blocks"></a> [isolated\_az\_subnet\_cidr\_blocks](#output\_isolated\_az\_subnet\_cidr\_blocks) | n/a |
| <a name="output_isolated_az_subnet_ids"></a> [isolated\_az\_subnet\_ids](#output\_isolated\_az\_subnet\_ids) | n/a |
| <a name="output_isolated_az_subnet_map"></a> [isolated\_az\_subnet\_map](#output\_isolated\_az\_subnet\_map) | n/a |
| <a name="output_private_az_ngw_ids"></a> [private\_az\_ngw\_ids](#output\_private\_az\_ngw\_ids) | n/a |
| <a name="output_private_az_route_table_ids"></a> [private\_az\_route\_table\_ids](#output\_private\_az\_route\_table\_ids) | n/a |
| <a name="output_private_az_subnet_arns"></a> [private\_az\_subnet\_arns](#output\_private\_az\_subnet\_arns) | n/a |
| <a name="output_private_az_subnet_cidr_blocks"></a> [private\_az\_subnet\_cidr\_blocks](#output\_private\_az\_subnet\_cidr\_blocks) | n/a |
| <a name="output_private_az_subnet_ids"></a> [private\_az\_subnet\_ids](#output\_private\_az\_subnet\_ids) | n/a |
| <a name="output_private_az_subnet_map"></a> [private\_az\_subnet\_map](#output\_private\_az\_subnet\_map) | n/a |
| <a name="output_private_zone_id"></a> [private\_zone\_id](#output\_private\_zone\_id) | n/a |
| <a name="output_public_az_ngw_ids"></a> [public\_az\_ngw\_ids](#output\_public\_az\_ngw\_ids) | n/a |
| <a name="output_public_az_route_table_ids"></a> [public\_az\_route\_table\_ids](#output\_public\_az\_route\_table\_ids) | n/a |
| <a name="output_public_az_subnet_arns"></a> [public\_az\_subnet\_arns](#output\_public\_az\_subnet\_arns) | n/a |
| <a name="output_public_az_subnet_cidr_blocks"></a> [public\_az\_subnet\_cidr\_blocks](#output\_public\_az\_subnet\_cidr\_blocks) | n/a |
| <a name="output_public_az_subnet_ids"></a> [public\_az\_subnet\_ids](#output\_public\_az\_subnet\_ids) | n/a |
| <a name="output_public_az_subnet_map"></a> [public\_az\_subnet\_map](#output\_public\_az\_subnet\_map) | n/a |
| <a name="output_s3_gw_endpoint_arn"></a> [s3\_gw\_endpoint\_arn](#output\_s3\_gw\_endpoint\_arn) | n/a |
| <a name="output_tgw_az_ngw_ids"></a> [tgw\_az\_ngw\_ids](#output\_tgw\_az\_ngw\_ids) | n/a |
| <a name="output_tgw_az_route_table_ids"></a> [tgw\_az\_route\_table\_ids](#output\_tgw\_az\_route\_table\_ids) | n/a |
| <a name="output_tgw_az_subnet_arns"></a> [tgw\_az\_subnet\_arns](#output\_tgw\_az\_subnet\_arns) | n/a |
| <a name="output_tgw_az_subnet_cidr_blocks"></a> [tgw\_az\_subnet\_cidr\_blocks](#output\_tgw\_az\_subnet\_cidr\_blocks) | n/a |
| <a name="output_tgw_az_subnet_ids"></a> [tgw\_az\_subnet\_ids](#output\_tgw\_az\_subnet\_ids) | n/a |
| <a name="output_tgw_az_subnet_map"></a> [tgw\_az\_subnet\_map](#output\_tgw\_az\_subnet\_map) | n/a |
| <a name="output_transit_gateway_id"></a> [transit\_gateway\_id](#output\_transit\_gateway\_id) | n/a |
| <a name="output_transit_gateway_vpc_attachment_id"></a> [transit\_gateway\_vpc\_attachment\_id](#output\_transit\_gateway\_vpc\_attachment\_id) | n/a |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | n/a |
| <a name="output_vpc_default_network_acl_id"></a> [vpc\_default\_network\_acl\_id](#output\_vpc\_default\_network\_acl\_id) | n/a |
| <a name="output_vpc_default_route_table_id"></a> [vpc\_default\_route\_table\_id](#output\_vpc\_default\_route\_table\_id) | n/a |
| <a name="output_vpc_default_security_group_id"></a> [vpc\_default\_security\_group\_id](#output\_vpc\_default\_security\_group\_id) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
| <a name="output_vpc_main_route_table_id"></a> [vpc\_main\_route\_table\_id](#output\_vpc\_main\_route\_table\_id) | n/a |