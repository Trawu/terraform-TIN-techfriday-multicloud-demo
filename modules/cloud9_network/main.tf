
# Security groups

resource "openstack_networking_secgroup_v2" "secgroup_allow_all_my_ip" {
  name        = "allow-all-my-address"
  description = "Allow all from my Address"
}

resource "openstack_networking_secgroup_v2" "secgroup_allow_public" {
  name        = "allow-public"
  description = "Allow HTTP, HTTPS from internet"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_allow_tcp_all" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = var.myip
  security_group_id = openstack_networking_secgroup_v2.secgroup_allow_all_my_ip.id
}
resource "openstack_networking_secgroup_rule_v2" "secgroup_allow_udp_all" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  remote_ip_prefix  = var.myip
  security_group_id = openstack_networking_secgroup_v2.secgroup_allow_all_my_ip.id
}
resource "openstack_networking_secgroup_rule_v2" "secgroup_allow_icmp_all" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = var.myip
  security_group_id = openstack_networking_secgroup_v2.secgroup_allow_all_my_ip.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_allow_public_http" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 80
  port_range_max = 80
  security_group_id = openstack_networking_secgroup_v2.secgroup_allow_public.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_allow_public_https" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 443
  port_range_max = 443
  security_group_id = openstack_networking_secgroup_v2.secgroup_allow_public.id
}

# Network essentials

resource "openstack_networking_router_v2" "router_public_az2" {
  name                = "router-public-az2"
  admin_state_up      = "true"
  external_network_id = var.az2_external_network_id
}

resource "openstack_networking_network_v2" "network_public_az2" {
  name           = "network-public-az2"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_public_az2" {
  name            = "subnet-public-az2"
  network_id      = openstack_networking_network_v2.network_public_az2.id
  cidr            = "172.18.40.0/24"
  gateway_ip      = "172.18.40.254"
  dns_nameservers = ["1.1.1.1", "8.8.8.8"]
  ip_version      = 4
}

resource "openstack_networking_router_interface_v2" "router_public_az2_int" {
  router_id = openstack_networking_router_v2.router_public_az2.id
  subnet_id = openstack_networking_subnet_v2.subnet_public_az2.id
}

# VPNaaS settings

resource "openstack_vpnaas_endpoint_group_v2" "remote_endpoints" {
  name = "remote_endpoints"
  type = "cidr"
  endpoints = [var.aws_network]
  depends_on = [var.aws_network]
}
resource "openstack_vpnaas_endpoint_group_v2" "local_endpoint" {
  name = "local_endpoint"
  type = "subnet"
  endpoints = [ openstack_networking_subnet_v2.subnet_public_az2.id ]
}
resource "openstack_vpnaas_ike_policy_v2" "ike_policy_1" {
  name                  = "ikev1-max"
  auth_algorithm        = "sha256"
  encryption_algorithm  = "aes-256"
  pfs                   = "group14"
}

resource "openstack_vpnaas_ipsec_policy_v2" "ipsec_policy_1" {
  name = "ipsec-max"
  auth_algorithm        = "sha256"
  encryption_algorithm  = "aes-256"
  pfs                   = "group14"
}

resource "openstack_vpnaas_service_v2" "service_1" {
  name           = "Demo_VPNaaS"
  router_id      = openstack_networking_router_v2.router_public_az2.id
  admin_state_up = "true"
}

resource "openstack_vpnaas_site_connection_v2" "conn_1" {
  name              = "Test_connection_1"
  ikepolicy_id      = openstack_vpnaas_ike_policy_v2.ike_policy_1.id
  ipsecpolicy_id    = openstack_vpnaas_ipsec_policy_v2.ipsec_policy_1.id
  vpnservice_id     = openstack_vpnaas_service_v2.service_1.id
  psk               = var.our_tunnel1_psk
  peer_address      = var.aws_tunnel1_ip
  peer_id           = var.aws_tunnel1_ip
  local_ep_group_id = openstack_vpnaas_endpoint_group_v2.local_endpoint.id
  peer_ep_group_id  = openstack_vpnaas_endpoint_group_v2.remote_endpoints.id
  depends_on = [var.aws_tunnel1_ip,var.our_tunnel1_psk]
}

resource "openstack_vpnaas_site_connection_v2" "conn_2" {
  name              = "Test_connection_2"
  ikepolicy_id      = openstack_vpnaas_ike_policy_v2.ike_policy_1.id
  ipsecpolicy_id    = openstack_vpnaas_ipsec_policy_v2.ipsec_policy_1.id
  vpnservice_id     = openstack_vpnaas_service_v2.service_1.id
  psk               = var.our_tunnel2_psk
  peer_address      = var.aws_tunnel2_ip
  peer_id           = var.aws_tunnel2_ip
  local_ep_group_id = openstack_vpnaas_endpoint_group_v2.local_endpoint.id
  peer_ep_group_id  = openstack_vpnaas_endpoint_group_v2.remote_endpoints.id
  depends_on = [var.our_tunnel2_psk, var.aws_tunnel2_ip]
}
