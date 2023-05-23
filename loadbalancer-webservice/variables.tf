# Variables

# name of your key pair
variable "keypair_name" {
  type    = string
  default = "mykeypairname"
}

# name of the private network (your project network)
variable "private_network_name" {
  type    = string
  default = "p123456-dev-network"
}

# name of the private subnet (in your project network)
variable "private_subnet_name" {
  type    = string
  default = "p123456-dev-subnet"
}

# name of the public network (global)
# ext01 is standard in pluscloud open
variable "public_network_name" {
  type    = string
  default = "ext01"
}

# Get openstack subnet data (ID) of private subnet
data "openstack_networking_subnet_v2" "private_subnet_data" {
  name = var.private_subnet_name
}

# data source of image to use
data "openstack_images_image_v2" "image" {
  name        = "Ubuntu 22.04" # Name of image to be used
  most_recent = true
}

# data source of flavor to use
data "openstack_compute_flavor_v2" "flavor" {
  name = "SCS-2V:2:20" # flavor to be used
}

# name of the cloud init
variable "user_data_filename" {
  type    = string
  default = "cloud-init.yaml"
}

# number of webservers you want to spawn
variable "server_count" {
  type    = number
  default = 2
}

# name of the loadbalancer
variable "loadbalancer_name" {
  type    = string
  default = "Web Service"
}
