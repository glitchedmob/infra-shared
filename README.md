# infra-shared

Shared Terraform modules for glitchedmob infrastructure. Referenced via `git::` source by other repos - not deployed directly.

## Scope

- **Terraform modules (`src/tf/modules`)**: reusable building blocks consumed by other infrastructure repositories.

## Modules

### ssh-key

Generates an ED25519 SSH key pair and stores it in AWS SSM Parameter Store.

**Usage:**

```hcl
module "ssh_key" {
  source               = "git::https://github.com/glitchedmob/infra-shared.git//src/tf/modules/ssh-key?ref=v1.0.0"
  name                 = "my-host"
  ssm_private_key_path = "/homelab/my-host/ssh-private-key"
}
```

**Variables:**

| Variable | Description | Required |
|----------|-------------|----------|
| `name` | Identifier for the SSH key | Yes |
| `ssm_private_key_path` | SSM parameter path for the private key | Yes |
| `ssm_public_key_path` | SSM parameter path for the public key | No |
| `key_version` | Version for writeonly_data resources | No (default: 1) |

**Outputs:**

| Output | Description |
|--------|-------------|
| `public_key` | The public SSH key |
| `ssm_path` | The SSM parameter path for the private key |
| `ssm_public_key_path` | The SSM parameter path for the public key |

## Usage

### Module Validation and Formatting

```bash
make help
make tf-format
make tf-lint-fix
make tf-validate
```
