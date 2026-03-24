# ssh-key

Generates an ED25519 SSH key pair and stores key material in AWS SSM Parameter Store.

## Usage

```hcl
module "ssh_key" {
  source = "git::https://github.com/glitchedmob/infra-shared.git//src/tf/modules/ssh-key?ref=v1.0.0"

  name                 = "my-host"
  ssm_private_key_path = "/homelab/my-host/ssh-private-key"
}
```

## Inputs

Required:

- `name`
- `ssm_private_key_path`

Optional:

- `ssm_public_key_path`
- `key_version` (default: `1`)

## Outputs

- `public_key`
- `ssm_path`
- `ssm_public_key_path`
