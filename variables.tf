variable "vsphere_server" {
  description = "URL of vSphere server"
}

variable "vsphere_user" {
  description = "Username for connecting to vSphere"
}

variable "vsphere_password" {
  description = "Password for vSphere connection"
}

variable "datacenter" {
  default = ""
}

variable "resource_pool" {
}

variable "folder" {
  default = ""
}

variable "datastore" {
  default = null
}

variable "datastore_cluster" {
  default = null
}

variable "network" {
}

variable "network_type" {
  description = "Type of the network. Can be either 'IPAM' or 'DHCP'"
}

variable "controller_vm_template" {
  description = "VM to use as a template for controllers"
}

variable "worker_vm_template" {
  description = "VM to use as a template for workers"
}

variable "ssh_private_key_file" {
  description = "Private key for SSH connections to created virtual machines"
}
variable "ssh_public_key_file" {
  description = "Public key for SSH connections to created virtual machines"
}

variable "quantity_controllers" {
  description = "Number of MKEx controller VMs to create"
  default     = 3
}

variable "quantity_workers" {
  description = "Number of MKEx worker VMs to create"
  default     = 3
}

variable "cpu_count_controllers" {
  description = "Number of CPUs in controllers VMs"
  default     = 2
}

variable "memory_count_controllers" {
  description = "Amount of memory in controllers VMs"
  default     = 16384
}

variable "cpu_count_workers" {
  description = "Number of CPUs in workers VMs"
  default     = 4
}

variable "memory_count_workers" {
  description = "Amount of memory in workers VMs"
  default     = 16384
}

#variable "network" {
#  description = "Network configuration"
#  type = map(object({
#    vsphere_network_name = string
#    type = string
#    ip_range = optional(string)
#    gateway = optional(string)
#    nameserver = optional(string)
#  }))
#}

variable "ip_range_controllers" {
  description = "IP addresses to be assigned to controllers VMs"
  default     = "192.168.10.2-192.168.10.10"
  type        = string
}

variable "ip_range_workers" {
  description = "IP addresses to be assigned to worker VMs"
  type        = string
  default     = "192.168.10.11-192.168.10.15"
}

variable "network_gateway" {
  description = "Gateway IP address to be used as default gateway for VMs"
  type        = string
  default     = "192.168.10.1"
}

variable "nameserver" {
  description = "DNS to be added to the VM network configuration"
  type        = string
  default     = "8.8.8.8"
}

variable "cluster_name" {
  description = "Name of the cluster (will be used as prefix for cluster nodes)"
  default     = "mkex-cluster"
}

variable "dockerhub_user" {
  description = "Docker Hub username to add docker hub auth to k0s cluster"
  default     = "user"
}

variable "dockerhub_password" {
  description = "Docker Hub password to add docker hub auth to k0s cluster"
  default     = "password"
}

variable "controller_disk_size" {
  description = "Manager disk size in GBs"
  default     = 40
}

variable "worker_disk_size" {
  description = "Worker disk size in GBs"
  default     = 60
}

variable "vm_user" {
  description = "Username that will be used to login to the VM"
}

variable "firmware" {
  description = "Firmware to be used for the VM. Possible options are 'bios' and 'efi'"
}

variable "external_address" {
  description = "IP address or DNS name that will be used to access the cluster"
}
