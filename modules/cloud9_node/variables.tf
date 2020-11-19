variable "network" {
  type = string
}

variable "floating_ip_pool" {
  type = string
}

variable "image_id" {
  type = string
}

variable "ssh_key" {
  type = string
  default = "demo"
}

variable "secgroup_allow_all_my_ip" {
  type = string
}

variable "secgroup_allow_public" {
  type = string
}

variable "availability_zone" {
  type = string
  default = "helsinki-2"
}
