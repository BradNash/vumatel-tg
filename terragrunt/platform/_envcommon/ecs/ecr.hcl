locals {
  base_source_url = "git::https://github.com/cloudposse/terraform-aws-ecr?ref=0.41.0"
}

inputs = {
  name                        = "ecr"
  image_tag_mutability        = "MUTABLE"
  use_fullname                = true
  force_delete                = true

  image_names = [
    "ods/cache-proxy",
    "shared/ecs-config-loader",
    "shared/ealen/echo-server"
  ]
  principals_readonly_access  = [
    "arn:aws:iam::339712841843:root",
    "arn:aws:iam::992382552351:root",
    "arn:aws:iam::211125628455:root",
    "arn:aws:iam::637423199642:root",
  ]

#   scan_images_on_push =  true
#   max_image_count =  500
#   enable_lifecycle_policy =  true
#   encryption_configuration =  null
#   principals_full_access =  []
#   principals_push_access =  []
#   principals_pull_though_access =  []
#   principals_lambda =  []
#   protected_tags =  []
#   replication_configurations =  []
#   organizations_readonly_access =  []
#   organizations_full_access =  []
#   organizations_push_access =  []
#   prefixes_pull_through_repositories =  []
}
