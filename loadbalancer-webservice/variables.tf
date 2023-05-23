# Variables
variable "keypair" {
  type    = string
  default = "cstelter"   # name of keypair created
}

variable "private_network_name" {
  type    = string
  default = "p500884-dev-network" # default internal network to be used
}

variable "private_subnet_name" {
  type    = string
  default = "p500884-dev-subnet"
}

variable "public_network_name" {
  type    = string
  default = "ext01" # default network to be used (floating ip)
}

# Get openstack subnet data (ID) of private subnet
data "openstack_networking_subnet_v2" "private_subnet_data" {
  name = var.private_subnet_name
}

# Get Image ID
data "openstack_images_image_v2" "image" {
  name        = "Ubuntu 22.04" # Name of image to be used
  most_recent = true
}

# Get flavor id
data "openstack_compute_flavor_v2" "flavor" {
  name = "SCS-2V:2:20" # flavor to be used
}

# Name of the cloud init
variable "user_data_filename" {
  type    = string
  default = "cloud-init.yaml"
}

# Number of webservers
variable "server_count" {
  type    = number
  default = 2
}

variable "loadbalancer_name" {
  type    = string
  default = "Loadbalancer Web Service"
}
