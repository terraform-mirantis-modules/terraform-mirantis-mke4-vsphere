terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
    }
  }
}

provider "vsphere" {
  vsphere_server = var.vsphere.server
  user           = var.vsphere.user
  password       = var.vsphere.password

  # Enable this if your vSphere server has a self-signed certificate
  allow_unverified_ssl = true
}
