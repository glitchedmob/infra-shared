# infra-shared

Shared Terraform modules for glitchedmob infrastructure. Referenced via `git::` source by other repos - not deployed directly.

## Scope

- **Terraform modules (`src/tf/modules`)**: reusable building blocks consumed by other infrastructure repositories.

## Modules

### proxmox-vm

Creates one Proxmox VM with static networking and an OS selected by `os_id`.

`enable_guest_agent = true` applies a module-managed cloud-init vendor-data snippet for the selected `os_id`.

The module uses fixed datastore IDs: `vmdata` for the OS disk and `local` for cloud-init.

**Usage:**

```hcl
module "k3s_node_01" {
  source = "git::https://github.com/glitchedmob/infra-shared.git//src/tf/modules/proxmox-vm?ref=v1.0.0"

  name                    = "sgfdevs-k3s-01"
  description             = "Managed by OpenTofu"
  tags                    = ["managed-by-tofu", "sgfdevs", "k3s"]
  node_name               = "x86-node-01"
  pool_id                 = "sgfdevs"
  os_id                   = "debian13"
  cpu_cores               = 4
  cpu_type                = "x86-64-v2-AES"
  memory_mb               = 8192
  disk_size_gb            = 80
  network_bridge          = "sgfdevs"
  network_cidr            = "10.20.4.0/22"
  ipv4_address            = "10.20.4.10"
  ipv4_gateway            = "10.20.4.1"
  dns_domain              = "local"
  dns_servers             = ["10.20.4.1"]
  vm_user                 = "admin"
  ssh_public_keys         = [module.ssh_key.public_key]

  enable_guest_agent = true
}
```

**Variables:**

| Variable | Description | Required |
|----------|-------------|----------|
| `name` | VM name | Yes |
| `description` | Optional VM description | No |
| `tags` | Optional list of VM tags | No |
| `node_name` | Proxmox node to run the VM on | Yes |
| `pool_id` | Proxmox pool ID for the VM | Yes |
| `os_id` | OS identifier from module catalog (`debian13`) | Yes |
| `cpu_cores` | Number of vCPU cores | Yes |
| `cpu_type` | Proxmox CPU type | No (default: `x86-64-v2-AES`) |
| `memory_mb` | Memory size in MiB | Yes |
| `disk_size_gb` | Disk size in GiB | Yes |
| `network_bridge` | Proxmox network bridge | Yes |
| `network_cidr` | IPv4 network CIDR block | Yes |
| `ipv4_address` | Static IPv4 address without prefix | Yes |
| `ipv4_gateway` | IPv4 default gateway | No (default: first host in `network_cidr`) |
| `dns_domain` | DNS search domain | Yes |
| `dns_servers` | DNS server IPv4 addresses | No (default: `[ipv4_gateway]`) |
| `vm_user` | Username configured in cloud-init | Yes |
| `ssh_public_keys` | SSH public keys injected for `vm_user` | Yes |
| `enable_guest_agent` | Enable guest agent and apply module default snippet for `os_id` | No (default: `true`) |
| `vendor_data_file_id` | Explicit cloud-init vendor-data file ID override | No |

**Outputs:**

| Output | Description |
|--------|-------------|
| `vm_id` | Proxmox VM ID |
| `name` | VM name |
| `ipv4_address` | Configured VM IPv4 address |

**Warning:**

- Setting `vendor_data_file_id` overrides the module-managed cloud-init vendor-data snippet. This can bypass expected baseline bootstrap behavior if your custom snippet is incomplete.

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
