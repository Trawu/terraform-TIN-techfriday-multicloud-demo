
terraform {
  required_version = ">= 0.13"
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
    upcloud = {
      source = "UpCloudLtd/upcloud"
      version = "~>1.0.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
