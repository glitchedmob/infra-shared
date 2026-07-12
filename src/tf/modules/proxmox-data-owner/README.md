# proxmox-data-owner

Creates one protected, permanently stopped Proxmox VM that owns one persistent disk. The VM is a lifecycle container only and has no operating system, network device, or cloud-init configuration.

Pass the `disk` output to one `proxmox-vm` module.

```hcl
data_disks = {
  scsi1 = module.k3s_01_data.disk
  scsi2 = module.k3s_01_backup.disk
}
```

```hcl
module "k3s_01_data" {
  source = "git::https://github.com/glitchedmob/infra-shared.git//src/tf/modules/proxmox-data-owner?ref=v1.0.0"

  name          = "lz-k3s-01-data"
  description   = "Persistent data disk owner; do not start or delete"
  tags          = ["tf", "lz", "k3s", "data-owner"]
  node_name     = "x86-node-01"
  pool_id       = "lz"
  datastore_id  = "vmdata"
  disk_size_gb  = 200
  disk_serial   = "lz-k3s-01-data"
}
```

Set `protect = false` and apply before removing the module to delete the owner VM and its disk.
