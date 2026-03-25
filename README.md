# infra-shared

Holds reusable OpenTofu modules shared by other LZ and SGFDEVS infrastructure repositories.

## Scope
- Owns: reusable module implementations for common infrastructure patterns.
- Owns: module-level validation and formatting workflow.

## Structure
- `src/tf/modules/proxmox-vm/`: Proxmox VM module with opinionated VM defaults.
- `src/tf/modules/ssh-key/`: SSH key generation and SSM storage module.
- `.github/workflows/`: Module validation and formatting checks.

## Run

```bash
make help
make tf-format
make tf-validate
```

## Operating constraints
- This repo is a module library and is not applied as an environment stack.
