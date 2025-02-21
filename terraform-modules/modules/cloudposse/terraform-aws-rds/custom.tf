data "dns_a_record_set" "rds_ip" {
  host = join("", aws_db_instance.default[*].address)
}

resource "aws_lb_target_group_attachment" "default_tg_attachment" {
  count = var.register_nlb ? 1 : 0
  target_group_arn = var.nlb_arn
  target_id        = data.dns_a_record_set.rds_ip.addrs[0]
  port             = 5432
}


variable "register_nlb" {
  type = bool
  default = false
}

 variable "nlb_arn" {
   type = string
   default = ""
 }
