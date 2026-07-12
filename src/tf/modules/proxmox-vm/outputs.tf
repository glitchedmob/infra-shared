output "vm_id" {
  description = "Proxmox VM ID"
  value       = proxmox_virtual_environment_vm.this.vm_id
}

output "name" {
  description = "VM name"
  value       = proxmox_virtual_environment_vm.this.name
}

output "ipv4_address" {
  description = "Configured VM IPv4 address"
  value       = var.ipv4_address
}

output "data_disks" {
  description = "Attached persistent data disks keyed by serial"
  value = {
    for interface, disk in var.data_disks :
    disk.serial => merge(disk, {
      interface = interface
    })
  }
}
