output "secgroup_allow_all_my_ip" {
  value = openstack_networking_secgroup_v2.secgroup_allow_all_my_ip.name
}

output "secgroup_allow_public" {
  value = openstack_networking_secgroup_v2.secgroup_allow_public.name
}

output "cloud9_vpnaas_ext_ip" {
  value = openstack_vpnaas_service_v2.service_1.external_v4_ip
}
output "cloud9_network" {
  value = openstack_networking_subnet_v2.subnet_public_az2.cidr
}
output "network_az2" {
  value = openstack_networking_network_v2.network_public_az2.name
}
