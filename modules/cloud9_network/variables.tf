variable "az2_external_network_id" {
  type = string
}
variable "myip" {
  type = string
  default = "0.0.0.0/0"
}

variable "aws_network" {
  type    = string
}

variable "our_tunnel1_psk" {
  type    = string
}
variable "our_tunnel2_psk" {
  type    = string
}
variable "aws_tunnel1_ip" {
  type    = string
}
variable "aws_tunnel2_ip" {
  type    = string
}
