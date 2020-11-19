
# Network setup in Cloud9
module "cloud9_network" {
  source                  = "./modules/cloud9_network"
  az2_external_network_id = var.az2_external_network_id
  aws_network             = module.aws.aws_network
  our_tunnel1_psk         = module.aws.our_tunnel1_psk
  our_tunnel2_psk         = module.aws.our_tunnel2_psk
  aws_tunnel1_ip          = module.aws.aws_tunnel1_ip
  aws_tunnel2_ip          = module.aws.aws_tunnel2_ip
}

# Network setup in AWS
module "aws" {
  source = "./modules/aws"
  cloud9_vpnaas_ext_ip  = module.cloud9_network.cloud9_vpnaas_ext_ip
  cloud9_network        = module.cloud9_network.cloud9_network
}

# Worker node installation in Cloud9
module "cloud9_node" {
  source = "./modules/cloud9_node"
  network                    = module.cloud9_network.network_az2
  floating_ip_pool           = var.az2_floating_ip_pool
  image_id                   = var.image_id
  secgroup_allow_all_my_ip   = module.cloud9_network.secgroup_allow_all_my_ip
  secgroup_allow_public      = module.cloud9_network.secgroup_allow_public
}

# Worker node installation in UpCloud
module "upcloud" {
  source = "./modules/upcloud"
}
