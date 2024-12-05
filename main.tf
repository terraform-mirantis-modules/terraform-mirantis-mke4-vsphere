locals {
  controllers_start_ip         = split("-", var.ip_range_controllers)[0]
  controllers_end_ip           = split("-", var.ip_range_controllers)[1]
  workers_start_ip          = split("-", var.ip_range_workers)[0]
  workers_end_ip            = split("-", var.ip_range_workers)[1]

  controllers_start_parts      = split(".", local.controllers_start_ip)
  controllers_end_parts        = split(".", local.controllers_end_ip)
  controllers_start_last_octet = tonumber(local.controllers_start_parts[3])
  workers_start_parts       = split(".", local.workers_start_ip)
  workers_end_parts         = split(".", local.workers_end_ip)
  workers_start_last_octet  = tonumber(local.workers_start_parts[3])

  controllers_ips              = [for i in range(var.quantity_controllers) : format("${local.controllers_start_parts[0]}.${local.controllers_start_parts[1]}.${local.controllers_start_parts[2]}.%s", sum([local.controllers_start_last_octet, i]))]
  workers_ips               = [for i in range(var.quantity_workers) : format("${local.workers_start_parts[0]}.${local.workers_start_parts[1]}.${local.workers_start_parts[2]}.%s", sum([local.workers_start_last_octet, i]))]

  controllers_hostnames        = [for i in range(var.quantity_controllers) : "${var.cluster_name}-ctr${(i+1)}"]
  workers_hostnames         = [for i in range(var.quantity_workers) : "${var.cluster_name}-wrk${(i+1)}"]
}

module "controllers" {
  source               = "./modules/virtual_machine"
  count                = var.quantity_controllers
  hostname             = local.controllers_hostnames[count.index]
  resource_pool_id     = data.vsphere_resource_pool.resource_pool.id
  datastore_id         = var.datastore == null ? null : data.vsphere_datastore.datastore[0].id
  datastore_cluster_id = var.datastore_cluster == null ? null: data.vsphere_datastore_cluster.datastore_cluster[0].id
  folder               = var.folder
  network_id           = data.vsphere_network.network.id
  template_vm          = data.vsphere_virtual_machine.controller_vm_template
  disk_size            = var.controller_disk_size
  vm_user              = var.vm_user
  cpu_count            = var.cpu_count_controllers
  memory_count         = var.memory_count_controllers
  firmware             = var.firmware
  user_data            = base64encode(
                           templatefile(
                             "${path.module}/helpers/cloudinit/userdata-ctr.yaml", 
                             {
                               ssh_key = file(var.ssh_public_key_file), 
                               hostname = local.controllers_hostnames[count.index], 
                               user = var.vm_user,
                               external_address = var.external_address,
                               dockerhub_user = var.dockerhub_user,
                               dockerhub_password = var.dockerhub_password
                             }
                           )
                         )
  meta_data            = var.network_type == "IPAM" ? base64encode(
                           templatefile(
                             "${path.module}/helpers/cloudinit/metadata-ipam.yaml",
                             { 
                               ip_addr = local.controllers_ips[count.index], 
                               gateway_addr = var.network_gateway, 
                               hostname = local.controllers_hostnames[count.index], 
                               nameserver = var.nameserver 
                             }
                           )
                         ) : base64encode(
                           templatefile(
                             "${path.module}/helpers/cloudinit/metadata-dhcp.yaml",
                             { 
                               hostname = local.controllers_hostnames[count.index], 
                             }
                           )
                         )
}

module "workers" {
  source               = "./modules/virtual_machine"
  count                = var.quantity_workers
  hostname             = local.workers_hostnames[count.index]
  resource_pool_id     = data.vsphere_resource_pool.resource_pool.id
  datastore_id         = var.datastore == null ? null : data.vsphere_datastore.datastore[0].id
  datastore_cluster_id = var.datastore_cluster == null ? null: data.vsphere_datastore_cluster.datastore_cluster[0].id
  folder               = var.folder
  network_id           = data.vsphere_network.network.id
  template_vm          = data.vsphere_virtual_machine.worker_vm_template
  disk_size            = var.worker_disk_size
  vm_user              = var.vm_user
  cpu_count            = var.cpu_count_workers
  memory_count         = var.memory_count_workers
  firmware             = var.firmware
  user_data            = base64encode(
                           templatefile(
                             "${path.module}/helpers/cloudinit/userdata-wrk.yaml",
                             { 
                               ssh_key = file(var.ssh_public_key_file), 
                               hostname = local.workers_hostnames[count.index], 
                               user = var.vm_user,
                               dockerhub_user = var.dockerhub_user,
                               dockerhub_password = var.dockerhub_password
                             }
                           )
                         )
  meta_data            = var.network_type == "IPAM" ? base64encode(
                           templatefile(
                             "${path.module}/helpers/cloudinit/metadata-ipam.yaml",
                             { 
                               ip_addr = local.workers_ips[count.index], 
                               gateway_addr = var.network_gateway, 
                               hostname = local.workers_hostnames[count.index], 
                               nameserver = var.nameserver 
                             }
                           )
                         ) : base64encode(
                           templatefile(
                             "${path.module}/helpers/cloudinit/metadata-dhcp.yaml",
                             { 
                               hostname = local.workers_hostnames[count.index], 
                             }
                           )
                         )
}
