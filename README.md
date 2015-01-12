Genstall
========

Gentoo Linux Install Scripts

Usage: On Bare Metal
--------------------
**This will cause destructive file system changes**

Boot from a [Live CD](http://www.sysresccd.org/SystemRescueCd_Homepage) and run:

	curl -L https://api.github.com/repos/p8952/genstall/tarball > genstall.tar.gz
	tar xvf genstall.tar.gz
	cd p8952-genstall-*
	bash install.sh


Usage: With Packer & Vagrant
----------------------------

Prerequisites:

* [Packer](http://www.packer.io/)
* [Vagrant](http://www.vagrantup.com/)

Build VirtualBox VM with Packer:

	packer build --only=gentoo-amd64-vbox packer/gentoo-amd64.json

Import VirtualBox VM to Vagrant:

	vagrant box add gentoo-amd64 gentoo-amd64-vbox-<timestamp>.box

Vagrantfile for VirtualBox VM:

	Vagrant.configure(2) do |config|
		config.vm.box = "gentoo-amd64"
	end

Launch VirtualBox VM with Vagrant:

	vagrant up
	vagrant ssh
	exit
	vagrant destroy

Build AWS AMI with Packer:

	export AWS_ACCESS_KEY="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	export AWS_SECRET_KEY="ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
	packer build --only=gentoo-amd64-aws packer/gentoo-amd64.json

Import AWS AMI to Vagrant:

	vagrant box add gentoo-amd64 gentoo-amd64-aws-<timestamp>.box

Vagrantfile for AWS AMI:

	Vagrant.configure(2) do |config|
			config.vm.box = "gentoo-amd64"
			config.vm.provider :aws do |aws, override|
					aws.instance_type = "t2.micro"
					aws.region = "eu-west-1"
					aws.keypair_name = "AWS-Key"
					override.ssh.username = "ec2-user"
					override.ssh.private_key_path = "~/.ssh/AWS-Key.pem"
			end
	end

Launch AWS AMI with Vagrant:

	vagrant plugin install vagrant-aws
	vagrant up --provider=aws
	vagrant ssh
	exit
	vagrant destroy

Refer to [Vagrant's documentation](http://www.vagrantup.com/v2/) for further usage.

Configuration
-------------

Without any user defined configuration genstall will attempt to install a basic
Gentoo system as per the [Gentoo
Handbook](http://www.gentoo.org/doc/en/handbook/).

Additional settings can be configured in genstall.d/00-settings.sh, such as
enabling LVM, installing custom software (Puppet, Chef, ect), and setting
metadata (hostname, root password, network settings).

Variables in genstall.d/00-settings.sh prefixed with _ are internal variables
and should not be changed.

Variable                 |Value
--------                 |-----
DIST\_MIRROR             | [Portage Distfile Mirror(s)](http://www.gentoo.org/main/en/mirrors2.xml)
SYNC\_MIRROR             | [Portage Rsync Mirror(s)](http://www.gentoo.org/main/en/mirrors-rsync.xml)
BOOT\_SIZE               | Size of the boot partition, eg: +256M
SWAP\_SIZE               | Size of the swap partition, eg: +1G
ROOT\_SIZE               | Size of the root partition, eg: +10G
BOOT\_FS                 | The file system of the boot partition, eg: ext2
ROOT\_FS                 | The file system of the root partition, eg: ext4
TIMEZONE                 | The system's timezone, eg: Europe/London
HOSTNAME                 | The system's hostname, eg: my-gentoo-box
PASSWORD                 | The system's root password
SOFTWARE                 | Applications to be installed, eg: syslog & cron
DAEMONS                  | Daemons to be added to the default runlevel, eg: sshd
