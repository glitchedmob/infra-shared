variable "name" {
  description = "Data owner VM name"
  type        = string
}

variable "description" {
  description = "Optional data owner VM description"
  type        = string
  default     = null
}

variable "tags" {
  description = "Optional list of data owner VM tags"
  type        = list(string)
  default     = []
}

variable "node_name" {
  description = "Proxmox node that hosts the data owner and its consumer"
  type        = string
}

variable "pool_id" {
  description = "Proxmox pool ID for the data owner VM"
  type        = string
}

variable "vm_id" {
  description = "Optional fixed Proxmox VM ID"
  type        = number
  default     = null
}

variable "protect" {
  description = "Enable Proxmox deletion protection for the data owner VM and disk"
  type        = bool
  default     = true
}

variable "datastore_id" {
  description = "Proxmox datastore that holds the persistent disk"
  type        = string
}

variable "disk_size_gb" {
  description = "Persistent disk size in GiB"
  type        = number

  validation {
    condition     = var.disk_size_gb >= 1
    error_message = "disk_size_gb must be at least 1 GiB."
  }
}

variable "disk_serial" {
  description = "ASCII disk serial exposed to the consumer guest (maximum 20 characters)"
  type        = string

  validation {
    condition     = length(var.disk_serial) >= 1 && length(var.disk_serial) <= 20 && can(regex("^[[:ascii:]]+$", var.disk_serial))
    error_message = "disk_serial must contain 1-20 ASCII characters."
  }
}
