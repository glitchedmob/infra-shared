locals {
  effective_tags = sort(distinct([for tag in var.tags : trimspace(tag) if trimspace(tag) != ""]))
}

resource "proxmox_virtual_environment_vm" "this" {
  name        = var.name
  description = var.description
  tags        = local.effective_tags
  node_name   = var.node_name
  pool_id     = var.pool_id
  vm_id       = var.vm_id

  started    = false
  on_boot    = false
  protection = var.protect

  disk {
    datastore_id = var.datastore_id
    interface    = "scsi0"
    serial       = var.disk_serial
    size         = var.disk_size_gb
  }

}
