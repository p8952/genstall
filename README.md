Genstall
========

Gentoo Linux Install Scripts

Usage: On Bare Metal
--------------------
**This will cause destructive file system changes**

Boot from a [Live CD](http://www.sysresccd.org/SystemRescueCd_Homepage) and run:

    curl -L https://api.github.com/repos/p8952/genstall/tarball > genstall.tar.gz
	tar xvf genstall.tar.gz
	cd p8952-genstall-xxxx
	bash install.sh


Usage: With Veewee & Vagrant
----------------------------

Install [Veewee](https://github.com/jedi4ever/veewee) and
[Vagrant](http://www.vagrantup.com/) packages for your distribution:

    emerge -av app-emulation/vagrant
	gem install veewee --no-ri --no-rdoc

Clone and enter the repository:

    git clone https://github.com/p8952/genstall.git
	cd genstall

Build the base box using Veewee:

    veewee vbox build gentoo-amd64 --auto --nogui

Import the base box to Vagrant:

    vagrant box add gentoo-amd64 gentoo-amd64.box

Refer to [Vagrant's documentation](http://www.vagrantup.com/v2/) for further
usage.

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
