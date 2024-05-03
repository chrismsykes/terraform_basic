data "vsphere_datacenter" "dc" {
  name = "name-of-vsphere-datacenter"
}

data "vsphere_datastore" "datastore" {
  name          = "name-of-vsphere-datastore"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = "name-of-vsphere-cluster/Resources"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_content_library" "library" {
  name = "name-of-vsphere-content-library"
}

data "vsphere_network" "network" {
  name          = "name-of-vsphere-vm-network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_content_library_item" "ubuntu_template" {
  type            = "vmtx"
  name            = "name-of-vsphere-content-library-template"
  library_id      = data.vsphere_content_library.library.id
}