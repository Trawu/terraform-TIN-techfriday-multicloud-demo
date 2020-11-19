
output "aws_network" {
  value = aws_vpc.demo_network.cidr_block
}

output "our_tunnel1_psk" {
  value = aws_vpn_connection.cloud9_vpn.tunnel1_preshared_key
}
output "our_tunnel2_psk" {
  value = aws_vpn_connection.cloud9_vpn.tunnel2_preshared_key
}
output "aws_tunnel1_ip" {
  value = aws_vpn_connection.cloud9_vpn.tunnel1_address
}
output "aws_tunnel2_ip" {
  value = aws_vpn_connection.cloud9_vpn.tunnel2_address
}

### UNDERCONSTRUCTION EKS CONFIGURATION IS COMMENTED OUT ####


/*
output "endpoint" {
  value = aws_eks_cluster.example.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.example.certificate_authority[0].data
}
*/
