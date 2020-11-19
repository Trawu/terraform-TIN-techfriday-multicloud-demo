#AWS network config and VPN
resource "aws_vpc" "demo_network" {
  cidr_block = var.aws_local_network
}
resource "aws_subnet" "demo_subnet" {
  vpc_id     = aws_vpc.demo_network.id
  cidr_block = aws_vpc.demo_network.cidr_block

}
resource "aws_customer_gateway" "cloud9_vpnaas" {
  bgp_asn    = 65000
  ip_address = var.cloud9_vpnaas_ext_ip
  type       = "ipsec.1"
  depends_on  = [var.cloud9_vpnaas_ext_ip]
}

resource "aws_vpn_gateway" "vpn_to_cloud9" {
  vpc_id = aws_vpc.demo_network.id
}

resource "aws_vpn_connection" "cloud9_vpn" {
  vpn_gateway_id      = aws_vpn_gateway.vpn_to_cloud9.id
  customer_gateway_id = aws_customer_gateway.cloud9_vpnaas.id
  type                = "ipsec.1"
  static_routes_only  = true
}

resource "aws_vpn_connection_route" "cloud9_network" {
  destination_cidr_block = var.cloud9_network
  vpn_connection_id      = aws_vpn_connection.cloud9_vpn.id
  depends_on  = [var.cloud9_network]
}



### UNDERCONSTRUCTION EKS CONFIGURATION IS COMMENTED OUT ####


/*
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.demo_network.id

}



resource "aws_route" "route_to_cloud9" {
  route_table_id = aws_route_table.route_table.id

  # Cloud9 Cidr
  destination_cidr_block = var.cloud9_network
  gateway_id             = aws_vpn_gateway.vpn_to_cloud9.id
  depends_on  = [var.cloud9_network]
}


# AES IAM ROLE FOR EKS
resource "aws_iam_role" "example" {
  name = "eks-cluster-example"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.example.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "example-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.example.name
}


# AWS EKS kluster creation
resource "aws_eks_cluster" "example" {
  name     = "example"
  role_arn = aws_iam_role.example.arn

  vpc_config {
    subnet_ids = [aws_subnet.example1.id, aws_subnet.example2.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
  ]
}
*/
