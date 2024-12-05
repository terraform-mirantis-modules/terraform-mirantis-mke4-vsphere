#locals {
#
#  managers_start_ip         = split("-", var.ip_range_managers)[0]
#  managers_end_ip           = split("-", var.ip_range_managers)[1]
#  workers_start_ip          = split("-", var.ip_range_workers)[0]
#  workers_end_ip            = split("-", var.ip_range_workers)[1]
#
#  managers_start_parts      = join("", [ for i in split(".", local.managers_start_ip) : format("%08b", tonumber(i)) ])
#  managers_end_parts        = split(".", local.managers_end_ip)
#  managers_start_last_octet = tonumber(local.managers_start_parts[3])
#  workers_start_parts       = split(".", local.workers_start_ip)
#  workers_end_parts         = split(".", local.workers_end_ip)
#  workers_start_last_octet  = tonumber(local.workers_start_parts[3])
#
#  managers_ips              = [for i in range(var.quantity_managers) : format("${local.managers_start_parts[0]}.${local.managers_start_parts[1]}.${local.managers_start_parts[2]}.%s", sum([local.managers_start_last_octet, i]))]
#  workers_ips               = [for i in range(var.quantity_workers) : format("${local.workers_start_parts[0]}.${local.workers_start_parts[1]}.${local.workers_start_parts[2]}.%s", sum([local.workers_start_last_octet, i]))]
#
#  managers_hostnames        = [for i in range(var.quantity_managers) : "${var.cluster_name}-mngr${(i+1)}"]
#  workers_hostnames         = [for i in range(var.quantity_workers) : "${var.cluster_name}-wrk${(i+1)}"]
#}

#module "managers" {
#  source               = "./modules/virtual_machine"
#  count                = var.quantity_managers
#  hostname             = local.managers_hostnames[count.index]
#  resource_pool_id     = data.vsphere_resource_pool.resource_pool.id
#  datastore_id         = var.datastore == null ? null : data.vsphere_datastore.datastore[0].id
#  datastore_cluster_id = var.datastore_cluster == null ? null: data.vsphere_datastore_cluster.datastore_cluster[0].id
#  folder               = var.folder
#  network_id           = data.vsphere_network.network.id
#  template_vm          = data.vsphere_virtual_machine.manager_vm_template
#  disk_size            = var.manager_disk_size
#  vm_user              = var.vm_user
#  cpu_count            = var.cpu_count_managers
#  memory_count         = var.memory_count_managers
#  firmware             = var.firmware
#  user_data            = base64encode(
#                           templatefile(
#                             "${path.module}/helpers/cloudinit/userdata-mngr.yaml", 
#                             {
#                               ssh_key = file(var.ssh_public_key_file), 
#                               hostname = local.managers_hostnames[count.index], 
#                               user = var.vm_user,
#                               external_address = var.external_address,
#                               dockerhub_user = var.dockerhub_user,
#                               dockerhub_password = var.dockerhub_password
#                             }
#                           )
#                         )
#  meta_data            = base64encode(
#                           templatefile(
#                             "${path.module}/helpers/cloudinit/metadata.yaml",
#                             { 
#                               ip_addr = local.managers_ips[count.index], 
#                               gateway_addr = var.network_gateway, 
#                               hostname = local.managers_hostnames[count.index], 
#                               nameserver = var.nameserver 
#                             }
#                           )
#                         )
#}

#calculate user data for each node and 
locals {


}
module "nodegroups" {
  for_each = var.nodegroups
  source               = "./modules/virtual_machine"
  node_count                = each.value.count
  hostname             = "${var.cluster_name}-${each.key}"
  resource_pool_id     = data.vsphere_resource_pool.resource_pool.id
  datastore_id         = var.datastore == null ? null : data.vsphere_datastore.datastore[0].id
  datastore_cluster_id = var.datastore_cluster == null ? null: data.vsphere_datastore_cluster.datastore_cluster[0].id
  folder               = var.folder
  network_id           = data.vsphere_network.network.id
  template_vm          = data.vsphere_virtual_machine[each.key].vm_template
  disk_size            = each.value.disk
  cpu_count            = each.value.cpu
  memory_count         = each.value.ram
  firmware             = each.value.firmware
  #  user_data            = base64encode(
  #                           templatefile(
  #                             "${path.module}/helpers/cloudinit/userdata-${each.key}.yaml", 
  #                             {
  #                               ssh_key = file(each.value.ssh_public_key_file), 
  #                               hostname = "${var.cluster_name}-${each.key}", 
  #                               user = each.value.user,
  #                               external_address = each.key == "controllers" ? var.external_address : null,
  #                               dockerhub_user = var.dockerhub_user,
  #                               dockerhub_password = var.dockerhub_password
  #                             }
  #                           )
  #                         )
  #  meta_data            = base64encode(
  #                           templatefile(
  #                             "${path.module}/helpers/cloudinit/metadata.yaml",
  #                             { 
  #                               ip_addr = local.managers_ips[count.index], 
  #                               gateway_addr = var.network_gateway, 
  #                               hostname = "${var.cluster_name}-${each.key}", 
  #                               nameserver = var.nameserver 
  #                             } 
  #                         )
  #                       )
}

#module "workers" {
#  source               = "./modules/virtual_machine"
#  count                = var.quantity_workers
#  hostname             = local.workers_hostnames[count.index]
#  resource_pool_id     = data.vsphere_resource_pool.resource_pool.id
#  datastore_id         = var.datastore == null ? null : data.vsphere_datastore.datastore[0].id
#  datastore_cluster_id = var.datastore_cluster == null ? null: data.vsphere_datastore_cluster.datastore_cluster[0].id
#  folder               = var.folder
#  network_id           = data.vsphere_network.network.id
#  template_vm          = data.vsphere_virtual_machine.worker_vm_template
#  disk_size            = var.worker_disk_size
#  vm_user              = var.vm_user
#  cpu_count            = var.cpu_count_workers
#  memory_count         = var.memory_count_workers
#  firmware             = var.firmware
#  user_data            = base64encode(
#                           templatefile(
#                             "${path.module}/helpers/cloudinit/userdata-wrk.yaml",
#                             { 
#                               ssh_key = file(var.ssh_public_key_file), 
#                               hostname = local.workers_hostnames[count.index], 
#                               user = var.vm_user,
#                               dockerhub_user = var.dockerhub_user,
#                               dockerhub_password = var.dockerhub_password
#                             }
#                           )
#                         )
#  meta_data            = base64encode(
#                           templatefile(
#                             "${path.module}/helpers/cloudinit/metadata.yaml",
#                             { 
#                               ip_addr = local.workers_ips[count.index], 
#                               gateway_addr = var.network_gateway, 
#                               hostname = local.workers_hostnames[count.index], 
#                               nameserver = var.nameserver 
#                             }
#                           )
#                         )
#}
