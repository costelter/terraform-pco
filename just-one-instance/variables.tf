# Variables

# name of your key pair
variable "keypair_name" {
  type    = string
  default = "cstelter"
}

# name of the private network (your project network)
variable "private_network_name" {
  type    = string
  default = "p500884-dev-network"
}

# name of the public network (global)
# ext01 is standard in pluscloud open
variable "public_network_name" {
  type    = string
  default = "ext01"
}

# list of the security groups you want to use
# "default" on pluscloud open allows ssh
variable "security_groups" {
  type    = list(string)
  default = ["default"]
}

# data source of image to use
data "openstack_images_image_v2" "image" {
  name        = "Ubuntu 22.04"
  most_recent = true
}

# data source of flavor to use
data "openstack_compute_flavor_v2" "flavor" {
  name = "SCS-2V:2:20"
}
 