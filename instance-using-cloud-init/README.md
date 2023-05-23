# instance with cloud-init

Before you fire your "terraform apply" make sure that you change the following variables in variables.tf:

* keypair_name - replace it with the name of your keypair
* private_network_name - replace it with the name of your project network

Optional changes:

* image (name) - the name of the OS image you want to use
* flavor (name) - the name of the flavor (instance size) you want to use

# cloud-init

The example does an update, installs a nginx webserver, changes the title in the default page and does a reboot.

# Further reading

For more information on cloud-init usage take a look into the examples in the official documentation.

[cloud-init documentation: Cloud config examples](https://cloudinit.readthedocs.io/en/latest/reference/examples.html)
