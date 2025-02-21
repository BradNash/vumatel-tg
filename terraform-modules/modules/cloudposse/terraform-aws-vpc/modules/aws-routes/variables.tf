variable "route_table_ids" {
  type        = list(string)
  description = "List of Route Table Ids"
}

variable "cidr_blocks" {
  type        = list(string)
  description = "List of CIDR Blocks"
}

variable "transit_gateway_id" {
  type = string
}
