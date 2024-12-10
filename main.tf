data "vsphere_datacenter" "dc" {
  name = var.vsphere.datacenter
}

data "vsphere_resource_pool" "resource_pool" {
  name          = var.vsphere.resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  count = var.vsphere.datastore == null && var.vsphere.datastore_cluster != null ? 0 : 1

  name          = var.vsphere.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore_cluster" "datastore_cluster" {
  count = var.vsphere.datastore_cluster == null && var.vsphere.datastore != null ? 0 : 1

  name          = var.vsphere.datastore_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  for_each = var.network_config
  name          = each.value.vsphere_network_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "vm_template" {
  for_each = var.nodegroups
  name          = each.value.template_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

module "nodegroups" {
  for_each = var.nodegroups
  source               = "./modules/virtual_machine"
  node_count                = each.value.count
  hostname             = "${var.cluster_name}-${each.key}"
  resource_pool_id     = data.vsphere_resource_pool.resource_pool.id
  datastore_id         = var.vsphere.datastore == null ? null : data.vsphere_datastore.datastore[0].id
  datastore_cluster_id = var.vsphere.datastore_cluster == null ? null: data.vsphere_datastore_cluster.datastore_cluster[0].id
  folder               = var.vsphere.folder
  network_id           = data.vsphere_network.network[each.value.network_config_name].id
  template_vm          = data.vsphere_virtual_machine.vm_template[each.key]
  disk_size            = each.value.disk
  cpu_count            = each.value.cpu
  memory_count         = each.value.ram
  firmware             = each.value.firmware
  network_config       = var.network_config[each.value.network_config_name]
  role                 = each.value.role
  docker_hub_username  = var.dockerhub_user
  docker_hub_pass      = var.dockerhub_password
  external_address     = var.external_address
  vm_user              = each.value.user 
  public_ssh_key       = file(each.value.ssh_public_key_file)
}
