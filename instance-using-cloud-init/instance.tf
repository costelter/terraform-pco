# Create security group
resource "openstack_compute_secgroup_v2" "secgroup_1" {
  name        = "allow_http_and_ssh_no2"
  description = "Allow http and ssh for number two"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

# Create user data aka cloud-init
data "template_file" "user_data" {
  template = file(var.user_data_file)
}

# Create an instance
resource "openstack_compute_instance_v2" "server" {
  name            = "number-two"  #Instance name
  image_id        = data.openstack_images_image_v2.image.id
  flavor_id       = data.openstack_compute_flavor_v2.flavor.id
  key_pair        = var.keypair
  security_groups = ["allow_http_and_ssh_no2"]

  network {
    name = var.network
  }

    user_data     = data.template_file.user_data.rendered
}

# Add floating IP (FIP)
resource "openstack_networking_floatingip_v2" "fip" {
  pool = var.public_network
}

resource "openstack_compute_floatingip_associate_v2" "fip" {
  floating_ip = openstack_networking_floatingip_v2.fip.address
  instance_id = openstack_compute_instance_v2.server.id
}

# Output private IP of instance
output "server_private_ip" {
 value = openstack_compute_instance_v2.server.access_ip_v4
}

# Output public IP of instance
output "server_floating_ip" {
 value = openstack_networking_floatingip_v2.fip.address
}
