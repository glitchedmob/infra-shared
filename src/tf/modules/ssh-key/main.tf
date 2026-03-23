ephemeral "tls_private_key" "this" {
  algorithm = "ED25519"
}

resource "writeonly_data" "public_key" {
  input_wo         = ephemeral.tls_private_key.this.public_key_openssh
  input_wo_version = var.key_version
}

resource "aws_ssm_parameter" "private_key" {
  name = var.ssm_private_key_path
  type = "SecureString"

  value_wo         = ephemeral.tls_private_key.this.private_key_openssh
  value_wo_version = var.key_version
}

resource "aws_ssm_parameter" "public_key" {
  count = var.ssm_public_key_path == null ? 0 : 1

  name = var.ssm_public_key_path
  type = "String"

  value_wo         = writeonly_data.public_key.output
  value_wo_version = var.key_version
}
