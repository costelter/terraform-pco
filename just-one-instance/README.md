# just one instance

Before you fire your "terraform apply" make sure that you change the following variables in variables.tf:

* keypair_name - replace it with the name of your keypair
* private_network_name - replace it with the name of your project network

Optional changes:

* image (name) - the name of the OS image you want to use
* flavor (name) - the name of the flavor (instance size) you want to use
