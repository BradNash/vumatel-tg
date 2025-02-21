resource "aws_api_gateway_vpc_link" "example" {
  count       = var.create_vpc_link == true ? 1 :0
  name        = module.this.id
  description = var.vpc_link_description
  target_arns = var.vpc_link_target_arns
}

variable "create_vpc_link" {
  description = "Whether to create a VPC link or not"
  type        = bool
  default     = false
}

variable "vpc_link_description" {
  description = "Description to give to the VPC link"
  type        = string
  default     = null
}

variable "vpc_link_target_arns" {
  description = "Target Arns to give to the VPC link"
  type        = list(string)
  default     = []
}
