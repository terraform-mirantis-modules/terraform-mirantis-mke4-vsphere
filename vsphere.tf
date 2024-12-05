data "vsphere_datacenter" "dc" {
  name = var.vsphere.datacenter
}

data "vsphere_resource_pool" "resource_pool" {
  name          = var.vsphere.resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  count = var.vsphere.datastore == null && var.vspheredatastore_cluster != null ? 0 : 1

  name          = var.vsphere.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore_cluster" "datastore_cluster" {
  count = var.vsphere.datastore_cluster == null && var.vsphere.datastore != null ? 0 : 1

  name          = var.vsphere.datastore_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  for_each = var.network
  name          = each.value.vsphere_network_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "vm_template" {
  for_each = var.nodegroup
  name          = each.value.template_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

