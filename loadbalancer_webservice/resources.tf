# Create security group
resource "openstack_compute_secgroup_v2" "sg_allow_web_and_ssh" {
  name        = "allow_http_and_ssh_web_server"
  description = "Allow http and ssh for web server"

  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }

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
  template = file(var.user_data_filename)
}

# Create an instance
resource "openstack_compute_instance_v2" "webserver" {
  count           = var.server_count
  name            = "webserver-${count.index + 1}"
  image_id        = data.openstack_images_image_v2.image.id
  flavor_id       = data.openstack_compute_flavor_v2.flavor.id
  key_pair        = var.keypair
  security_groups = ["allow_http_and_ssh_web_server"]

  network {
    name = var.private_network_name
  }

  user_data     = data.template_file.user_data.rendered
}

resource "openstack_lb_loadbalancer_v2" "lb_service" {
  name          = var.loadbalancer_name
  vip_subnet_id = "${data.openstack_networking_subnet_v2.private_subnet_data.id}"
}

resource "openstack_lb_listener_v2" "listener_80" {
  protocol        = "HTTP"
  protocol_port   = 80
  loadbalancer_id = "${openstack_lb_loadbalancer_v2.lb_service.id}"

  insert_headers = {
    X-Forwarded-For = "true"
  }
}

resource "openstack_lb_pool_v2" "pool_80" {
  name = "pool_service"
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  listener_id = "${openstack_lb_listener_v2.listener_80.id}"
}

resource "openstack_lb_member_v2" "pool_members" {
  count = length(openstack_compute_instance_v2.webserver)
  address = element(
    openstack_compute_instance_v2.webserver.*.access_ip_v4,
    count.index,
  )
  name = element(
    openstack_compute_instance_v2.webserver.*.name,
    count.index,
  )
  pool_id = "${openstack_lb_pool_v2.pool_80.id}"
  protocol_port = 80
}

resource "openstack_lb_monitor_v2" "monitor_80" {
  name = "monitor_pool_80"
  pool_id     = "${openstack_lb_pool_v2.pool_80.id}"
  type        = "HTTP"
  delay       = 5
  timeout     = 5
  max_retries_down = 3
  max_retries = 3
  http_method = "GET"
  expected_codes = 200
  url_path = "/"
}

# Create floating IP (FIP)
resource "openstack_networking_floatingip_v2" "fip" {
  pool = var.public_network_name
}

# Associate FIP to lb
resource "openstack_networking_floatingip_associate_v2" "fip_lb" {
  floating_ip = openstack_networking_floatingip_v2.fip.address
  port_id     = openstack_lb_loadbalancer_v2.lb_service.vip_port_id
}

# Output public IP of lb
output "lb_floating_ip" {
 value = openstack_networking_floatingip_v2.fip.address
}
