output "gar_server_ips" {
  value = [for vm in vsphere_virtual_machine.vm_gar : vm.guest_ip_addresses]
  description = "IP addresses of etcd servers"
}

output "gar_server_hostnames" {
  value = [for vm in vsphere_virtual_machine.vm_gar : vm.name]
  description = "Hostnames of etcd servers"
}