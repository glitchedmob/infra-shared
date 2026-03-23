variable "name" {
  description = "Identifier for the SSH key"
  type        = string
}

variable "key_version" {
  description = "Version for writeonly_data resources"
  type        = number
  default     = 1
}

variable "ssm_private_key_path" {
  description = "Full SSM parameter path for the private key"
  type        = string
}

variable "ssm_public_key_path" {
  description = "Optional full SSM parameter path for the public key"
  type        = string
  default     = null
}
