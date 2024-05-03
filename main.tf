resource "vsphere_virtual_machine" "vm_gar" {
  count            = 1
  name             = "gar${count.index + 1}"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = 2
  memory           = 2048
  guest_id         = "ubuntu64Guest"
  firmware         = "efi"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = 40
  }

  clone {
    template_uuid = data.vsphere_content_library_item.ubuntu_template.id

    customize {
      linux_options {
        host_name = "gar${count.index + 1}"
        domain    = "chillincool.net"
      }
      network_interface {
      }
    }
  }
}