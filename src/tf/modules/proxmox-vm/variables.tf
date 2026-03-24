variable "name" {
  description = "VM name"
  type        = string
}

variable "description" {
  description = "Optional VM description"
  type        = string
  default     = null
}

variable "tags" {
  description = "Optional list of VM tags"
  type        = list(string)
  default     = []
}

variable "node_name" {
  description = "Proxmox node to run the VM on"
  type        = string
}

variable "pool_id" {
  description = "Proxmox pool ID for the VM"
  type        = string
}

variable "os_id" {
  description = "OS identifier from this module's catalog (currently: debian13)"
  type        = string

  validation {
    condition     = contains(["debian13"], var.os_id)
    error_message = "Unsupported os_id. Supported values: debian13."
  }
}

variable "cpu_cores" {
  description = "Number of vCPU cores"
  type        = number

  validation {
    condition     = var.cpu_cores >= 1
    error_message = "cpu_cores must be at least 1."
  }
}

variable "cpu_type" {
  description = "Proxmox CPU type"
  type        = string
  default     = "x86-64-v2-AES"
}

variable "memory_mb" {
  description = "Memory size in MiB"
  type        = number

  validation {
    condition     = var.memory_mb >= 256
    error_message = "memory_mb must be at least 256 MiB."
  }
}

variable "disk_size_gb" {
  description = "Disk size in GiB"
  type        = number

  validation {
    condition     = var.disk_size_gb >= 1
    error_message = "disk_size_gb must be at least 1 GiB."
  }
}

variable "network_bridge" {
  description = "Proxmox network bridge"
  type        = string
}

variable "network_cidr" {
  description = "IPv4 network CIDR (for example 10.20.4.0/22)"
  type        = string

  validation {
    condition     = can(cidrhost(var.network_cidr, 1))
    error_message = "network_cidr must be a valid IPv4 CIDR block."
  }
}

variable "ipv4_address" {
  description = "Static IPv4 address without prefix"
  type        = string
}

variable "ipv4_gateway" {
  description = "Optional IPv4 default gateway. Defaults to first host in network_cidr."
  type        = string
  default     = null
}

variable "dns_domain" {
  description = "Optional DNS search domain"
  type        = string
  default     = "local"
}

variable "dns_servers" {
  description = "DNS server IPv4 addresses. Defaults to [ipv4_gateway] when omitted."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for server in var.dns_servers : trimspace(server) != ""])
    error_message = "dns_servers cannot include empty values."
  }
}

variable "vm_user" {
  description = "Username configured in cloud-init"
  type        = string
}

variable "ssh_public_keys" {
  description = "SSH public keys injected for vm_user"
  type        = list(string)

  validation {
    condition     = length(var.ssh_public_keys) > 0 && alltrue([for key in var.ssh_public_keys : trimspace(key) != ""])
    error_message = "ssh_public_keys must include at least one non-empty key."
  }
}

variable "enable_guest_agent" {
  description = "Enable the QEMU guest agent and apply module default vendor-data snippet for os_id"
  type        = bool
  default     = true
}

variable "vendor_data_file_id" {
  description = "Optional explicit cloud-init vendor-data file ID. Warning: this overrides module defaults and can break baseline VM bootstrap expectations if the custom snippet is incomplete."
  type        = string
  default     = null
}
