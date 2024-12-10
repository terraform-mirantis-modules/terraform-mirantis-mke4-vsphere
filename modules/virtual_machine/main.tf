data "external" "ip_addresses" {
  count = var.network_config.type == "IPAM" ? 1 : 0
  program = ["python3", "${path.module}/helpers/ipaddr.py"]

  query = {
    ip_range = var.network_config.ip_range
  }
}

resource "vsphere_virtual_machine" "vm" {
  count = var.node_count
  name             = "${var.hostname}-${count.index}"
  resource_pool_id = var.resource_pool_id
  datastore_id     = var.datastore_id == null ? null : var.datastore_id
  datastore_cluster_id     = var.datastore_cluster_id == null ? null : var.datastore_cluster_id
  firmware         = var.firmware 
  folder           = var.folder

  guest_id = var.template_vm.guest_id

  network_interface {
    network_id = var.network_id
  }

  cdrom {
    client_device = true
  }

  num_cpus = var.cpu_count

  memory = var.memory_count

  enable_disk_uuid = true # NB the VM must have disk.EnableUUID=1 for, e.g., k8s persistent storage.

  disk {
    label            = "${var.hostname}-${count.index}"
    size             = var.disk_size
    thin_provisioned = var.template_vm.disks.0.thin_provisioned
  }

  clone {
    template_uuid = var.template_vm.id
  }

    extra_config = {
      "guestinfo.userdata" = var.role == "worker" ? base64encode(
                              templatefile(
                                "${path.module}/helpers/cloudinit/userdata-wrk.yaml",
                                {
                                  hostname = "${var.hostname}-${count.index}"
                                  user = var.vm_user
                                  ssh_key = var.public_ssh_key
                                  dockerhub_user = var.docker_hub_username
                                  dockerhub_password = var.docker_hub_pass
                                }
                              )
                            ) : base64encode(
                              templatefile(
                                "${path.module}/helpers/cloudinit/userdata-ctr.yaml",
                                {
                                  hostname = "${var.hostname}-${count.index}"
                                  user = var.vm_user
                                  ssh_key = var.public_ssh_key
                                  dockerhub_user = var.docker_hub_username
                                  dockerhub_password = var.docker_hub_pass
                                  external_address = var.external_address
                                }
                              )
                            )
      "guestinfo.userdata.encoding" = "base64"
      "guestinfo.metadata" = var.network_config.type == "IPAM" ? base64encode(
                              templatefile(
                                "${path.module}/helpers/cloudinit/metadata-ipam.yaml",
                                {
                                  ip_addr = data.external.ip_addresses[0].result[count.index]
                                  gateway_addr = var.network_config.gateway
                                  hostname = "${var.hostname}-${count.index}"
                                  nameserver = var.network_config.nameserver
                                }
                              )
                            ) : base64encode(
                              templatefile(
                                "${path.module}/helpers/cloudinit/metadata-dhcp.yaml",
                                {
                                  hostname = "${var.hostname}-${count.index}"
                                }
                              )
                            )
      "guestinfo.metadata.encoding" = "base64"
    }
}
