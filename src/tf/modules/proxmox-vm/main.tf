locals {
  os_disk_datastore_id    = "vmdata"
  cloud_init_datastore_id = "vmdata"

  os_catalog = {
    debian13 = {
      import_from                = "local:import/debian-13-generic-amd64.qcow2"
      operating_system_type      = "l26"
      guest_agent_vendor_data_id = "local:snippets/guest-agent-vendor-data-v1.yaml"
    }
  }

  selected_os = local.os_catalog[var.os_id]

  effective_vendor_data_file_id = coalesce(
    var.vendor_data_file_id,
    var.enable_guest_agent ? local.selected_os.guest_agent_vendor_data_id : null
  )

  effective_ssh_public_keys = [for key in var.ssh_public_keys : trimspace(key)]
  effective_tags            = sort(distinct([for tag in var.tags : trimspace(tag) if trimspace(tag) != ""]))
  effective_ipv4_prefix     = tonumber(split("/", var.network_cidr)[1])
  effective_ipv4_gateway    = coalesce(var.ipv4_gateway, cidrhost(var.network_cidr, 1))
  effective_dns_servers     = length(var.dns_servers) > 0 ? var.dns_servers : [local.effective_ipv4_gateway]
}

resource "proxmox_virtual_environment_vm" "this" {
  name        = var.name
  description = var.description
  tags        = local.effective_tags
  node_name   = var.node_name
  pool_id     = var.pool_id

  started = true
  on_boot = true

  agent {
    enabled = var.enable_guest_agent
    trim    = true
    type    = "virtio"
  }

  cpu {
    cores = var.cpu_cores
    type  = var.cpu_type
  }

  memory {
    dedicated = var.memory_mb
    floating  = var.memory_mb
  }

  disk {
    datastore_id = local.os_disk_datastore_id
    import_from  = local.selected_os.import_from
    interface    = "scsi0"
    discard      = "on"
    size         = var.disk_size_gb
  }

  network_device {
    bridge = var.network_bridge
    model  = "virtio"
  }

  initialization {
    datastore_id        = local.cloud_init_datastore_id
    vendor_data_file_id = local.effective_vendor_data_file_id

    dns {
      domain  = var.dns_domain
      servers = local.effective_dns_servers
    }

    ip_config {
      ipv4 {
        address = format("%s/%d", var.ipv4_address, local.effective_ipv4_prefix)
        gateway = local.effective_ipv4_gateway
      }
    }

    user_account {
      username = var.vm_user
      keys     = local.effective_ssh_public_keys
    }
  }

  operating_system {
    type = local.selected_os.operating_system_type
  }
}
