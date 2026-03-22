output "public_key" {
  description = "The public SSH key"
  value       = writeonly_data.public_key.output
}

output "ssm_path" {
  description = "The SSM parameter path for the private key"
  value       = var.ssm_private_key_path
}

output "ssm_public_key_path" {
  description = "The SSM parameter path for the public key"
  value       = var.ssm_public_key_path
}
