# proxmox-vm

Creates one Proxmox VM with static IPv4 networking and an OS selected by `os_id`.

When `enable_guest_agent = true`, the module automatically applies a module-managed cloud-init vendor-data snippet for the selected `os_id`.

The module uses fixed datastore IDs:

- OS disk datastore: `vmdata`
- cloud-init datastore: `vmdata`

## Usage

```hcl
module "k3s_node_01" {
  source = "git::https://github.com/glitchedmob/infra-shared.git//src/tf/modules/proxmox-vm?ref=v1.0.0"

  name            = "sgfdevs-k3s-01"
  description     = "Managed by OpenTofu"
  tags            = ["tf", "sgfdevs", "k3s"]
  node_name       = "x86-node-01"
  pool_id         = "sgfdevs"
  os_id           = "debian13"
  cpu_cores       = 4
  memory_mb       = 8192
  disk_size_gb    = 80
  network_bridge  = "sgfdevs"
  network_cidr    = "10.20.4.0/22"
  ipv4_address    = "10.20.4.10"
  dns_domain      = "local"
  vm_user         = "admin"
  ssh_public_keys = [module.ssh_key.public_key]
}
```

## Inputs

Required:

- `name`
- `node_name`
- `pool_id`
- `os_id` (`debian13`)
- `cpu_cores`
- `memory_mb`
- `disk_size_gb`
- `network_bridge`
- `network_cidr`
- `ipv4_address`
- `vm_user`
- `ssh_public_keys`

Optional:

- `description`
- `tags` (normalized by module: trimmed, deduplicated, sorted)
- `cpu_type` (default: `x86-64-v2-AES`)
- `ipv4_gateway` (default: first host in `network_cidr`)
- `dns_domain` (default: `local`)
- `dns_servers` (default: `[ipv4_gateway]`)
- `enable_guest_agent` (default: `true`)
- `vendor_data_file_id`

## Outputs

- `vm_id`
- `name`
- `ipv4_address`

## Warning

Setting `vendor_data_file_id` overrides the module-managed vendor-data snippet. This can bypass expected baseline bootstrap behavior if your custom snippet is incomplete.
