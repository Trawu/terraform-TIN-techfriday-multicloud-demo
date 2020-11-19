# OpenStack fixed resources
variable "az2_external_network_id" {
  type    = string
  default = "58499f3f-208f-4448-9c2f-68b3393a7537"
}

variable "az2_floating_ip_pool" {
  type    = string
  default = "Public-Helsinki-2"
}

variable "image_id" {
  type = string
  # CentOS 7 latest, 26.11.2019
  default = "18e6a954-15d1-40ab-a1ae-e5f6e56cf6f5"
}

variable "aws_network" {
  type    = string
  default = ""
}

variable "our_tunnel1_psk" {
  type    = string
  default = ""
}
variable "our_tunnel2_psk" {
  type    = string
  default = ""
}
variable "aws_tunnel1_ip" {
  type    = string
  default = ""
}
variable "aws_tunnel2_ip" {
  type    = string
  default = ""
}
variable "secgroup_allow_all_my_ip" {
  type    = string
  default = ""
}

variable "secgroup_allow_public" {
  type    = string
  default = ""
}

variable "cloud9_vpnaas_ext_ip" {
  type    = string
  default = ""
}
variable "cloud9_network" {
  type    = string
  default = ""
}
variable "network_az2" {
  type    = string
  default = ""
}
