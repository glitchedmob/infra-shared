# infra-shared

Shared Terraform modules for glitchedmob infrastructure. This repository is consumed by other repos via `git::` module sources and is not applied directly.

## Modules

- `proxmox-vm`: create one Proxmox VM with opinionated defaults and `os_id`-based image/snippet selection. See `src/tf/modules/proxmox-vm/README.md`.
- `ssh-key`: generate an ED25519 SSH key pair and store it in SSM Parameter Store. See `src/tf/modules/ssh-key/README.md`.

## Development

```bash
make help
make tf-format
make tf-lint-fix
make tf-validate
```
