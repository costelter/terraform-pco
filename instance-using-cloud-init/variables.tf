# Variables
variable "keypair" {
  type    = string
  default = "cstelter"   # name of keypair created
}

variable "network" {
  type    = string
  default = "p500884-dev-network" # default internal network to be used
}

variable "public_network" {
  type    = string
  default = "ext01" # default network to be used (floating ip)
}

# Data sources
## Get Image ID
data "openstack_images_image_v2" "image" {
  name        = "Ubuntu 22.04" # Name of image to be used
  most_recent = true
}

## Get flavor id
data "openstack_compute_flavor_v2" "flavor" {
  name = "SCS-2V:2:20" # flavor to be used
}

## Name of the cloud init filebase64
variable "user_data_file" {
  type    = string
  default = "cloud-init.yaml"
}
