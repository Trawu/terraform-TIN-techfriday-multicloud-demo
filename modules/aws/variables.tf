variable "cloud9_vpnaas_ext_ip" {
  type    = string
}
variable "cloud9_network" {
  type    = string
}

variable "aws_local_network" {
  type    = string
  default = "10.0.0.0/24"
}
