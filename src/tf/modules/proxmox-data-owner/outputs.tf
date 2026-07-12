output "vm_id" {
  description = "Proxmox data owner VM ID"
  value       = proxmox_virtual_environment_vm.this.vm_id
}

output "name" {
  description = "Data owner VM name"
  value       = proxmox_virtual_environment_vm.this.name
}

output "disk" {
  description = "Persistent disk metadata required to attach the disk to one consumer VM"
  value = {
    datastore_id      = proxmox_virtual_environment_vm.this.disk[0].datastore_id
    path_in_datastore = proxmox_virtual_environment_vm.this.disk[0].path_in_datastore
    file_format       = proxmox_virtual_environment_vm.this.disk[0].file_format
    size              = proxmox_virtual_environment_vm.this.disk[0].size
    serial            = var.disk_serial
  }
}
