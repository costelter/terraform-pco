# Configure the OpenStack Provider
terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

## uncomment this or set OS_CLOUD env var
# provider "openstack" {
#   cloud  = "pluscloudopen" # cloud defined in cloud.yml file
# }
