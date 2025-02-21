variable "kms_key_id" {
  description = "The ID of the KMS key used to encrypt the secret. If not specified, the default AWS-managed key for Secrets Manager will be used."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "A prefix added to the secret name to ensure uniqueness. Typically used to indicate the environment or project."
  type        = string
  default     = null
}

variable "policy" {
  description = "A JSON-formatted policy that specifies who can access the secret and under what conditions."
  type        = string
  default     = null
}

variable "recovery_window_in_days" {
  description = "The number of days during which the secret can be recovered before it is permanently deleted."
  type        = number
  default     = 0
}

variable "replica" {
  description = "A list of maps that define the replication configuration for the secret, with each map containing the 'region' (Required) and 'kms_key_id' (Optional) fields. 'kms_key_id' can be the ARN, Key ID, or Alias of the AWS KMS key within the region the secret is replicated to. If not specified, Secrets Manager defaults to using the AWS account's default KMS key (aws/secretsmanager) in the region."
  type        = list(object({
    region     = string
    kms_key_id = optional(string)
  }))
  default = []
}


variable "force_overwrite_replica_secret" {
  description = "A boolean flag indicating whether to overwrite an existing replica secret in the target region. Defaults to false."
  type        = bool
  default     = false
}

variable "base64_encode_secret" {
  description = "Specifies whether to encode the secret string or not."
  type        = bool
  default     = false
}

variable "secret_map" {
  description = "Specifies text data that you want to encrypt and store in this version of the secret. Required if secret_binary is not set."
  type        = map(string)
  default = {}
}

variable "version_stages" {
  description = "Specifies a list of staging labels that are attached to this version of the secret. A staging label must be unique to a single version of the secret."
  type        = list(string)
  default     = []
}

variable "rotate_secret" {
  description = "Specifies whether to rotate the secret."
  type        = bool
  default     = false
}

variable "rotate_immediately" {
  description = "Specifies whether to rotate the secret immediately or wait until the next scheduled rotation window. Defaults to true."
  type        = bool
  default     = true
}

variable "rotation_lambda_arn" {
  description = "Specifies the ARN of the Lambda function that can rotate the secret. Must be supplied if the secret is not managed by AWS."
  type        = string
  default     = ""
}

variable "rotation_rules" {
  description = "A structure that defines the rotation configuration for this secret."
  type        = object({
    automatically_after_days = optional(number, 0)
    duration                 = optional(string, "")
    schedule_expression      = optional(string, "")
  })
  default = {}
}

variable "generate_random_password" {
  description = "Specifies whether to generate a random password."
  type        = bool
  default     = false
}

variable "password_names" {
  description = "A list of names to be used with generated passwords."
  type        = list(string)
  default     = []
}

variable "length" {
  description = "The length of the string desired. The minimum value for length is 1, and it must be greater than or equal to the sum of min_upper, min_lower, min_numeric, and min_special."
  type        = number
  default     = 20
}

variable "keepers" {
  description = "Arbitrary map of values that, when changed, will trigger recreation of the resource."
  type        = map(string)
  default = {}
}

variable "lower" {
  description = "Include lowercase alphabet characters in the result. Default value is true."
  type        = bool
  default     = true
}

variable "min_lower" {
  description = "Minimum number of lowercase alphabet characters in the result. Default value is 0."
  type        = number
  default     = 0
}

variable "min_numeric" {
  description = "Minimum number of numeric characters in the result. Default value is 0."
  type        = number
  default     = 0
}

variable "min_special" {
  description = "Minimum number of special characters in the result. Default value is 0."
  type        = number
  default     = 0
}

variable "min_upper" {
  description = "Minimum number of uppercase alphabet characters in the result. Default value is 0."
  type        = number
  default     = 0
}

variable "numeric" {
  description = "Include numeric characters in the result. Default value is true. If numeric, upper, lower, and special are all configured, at least one of them must be set to true."
  type        = bool
  default     = true
}

variable "override_special" {
  description = "Supply your own list of special characters to use for string generation. This overrides the default character list in the special argument. The special argument must still be set to true for any overwritten characters to be used in generation."
  type        = string
  default     = ""
}

variable "special" {
  description = "Include special characters in the result. These are !@#$%&*()-_=+[]{}<>:?. Default value is true."
  type        = bool
  default     = true
}

variable "upper" {
  description = "Include uppercase alphabet characters in the result. Default value is true."
  type        = bool
  default     = true
}




