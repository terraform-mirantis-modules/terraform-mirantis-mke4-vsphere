variable "role" {
  description = "Node role"
}

variable "network_config" {
    description = "VM network configuration"
}

variable "hostname" {
    description = "The name of the VM" 
}

variable "resource_pool_id" {
    description = "ID of the resource pool to create the VMs in"
}

variable "datastore_id" {
  default = null
}

variable "datastore_cluster_id" {
  default = null
}

variable "folder" {
    description = "Subfolder in the datacenter at which to create the VMs"
}

variable "network_id" {
    description = "ID of the network to attach the VMs to"
}

variable "template_vm" {
    description = "The template VM which will be cloned as the base for the new VMs"
}

variable "disk_size" {
    description = "Size of the disk drive for the VMs"
}

variable "cpu_count" {
  description = "Number of CPUs in manager and worker VMs"
  default     = 4
}

variable "memory_count" {
  description = "Amount of memory in manager and worker VMs"
  default     = 4096
}

variable "ip_prefix" {
  description = "IP prefix to be used for IP addresses"
  default     = 24
}

variable "docker_hub_username" {
  description = "Docker Hub username to add docker hub auth to k0s cluster"
  default     = "user"
}

variable "docker_hub_pass" {
  description = "Docker Hub password to add docker hub auth to k0s cluster"
  default     = "password"
}

variable "vm_user" {
  description = "Username that will be used to login to the VM"
}

variable "node_count" {
  description = "Number of nodes"
}

variable "firmware" {
  description = "Firmware to be used for the VM. Possible options are 'bios' and 'efi'"
}

variable "external_address" {
  description = "Address that will be used to connect to MKE4 cluster"
}

variable "public_ssh_key" {
  description = "Public SSH key that will be added to authorized_keys"
}
