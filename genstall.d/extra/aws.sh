#!/usr/bin/env bash
set -o errexit
source /tmp/00-settings.sh
[[ $(whoami) == 'root' ]] || exec sudo su -c $0 root

# Copy key system files to the gentoo chroot
\cp -rf /boot/* /mnt/gentoo/boot
\cp -rf /lib/modules/ /mnt/gentoo/lib
\cp -rf /etc/fstab /mnt/gentoo/etc/fstab
\cp -rf /etc/ssh/sshd_config /mnt/gentoo/etc/ssh/sshd_config

# Delete the vagrant user and replace it with the ec2-user
$_CHROOT userdel -rf vagrant
rm -rf /mnt/gentoo/home/vagrant
$_CHROOT useradd -m -s /bin/bash ec2-user
$_CHROOT passwd ec2-user << EOF
ec2-user
ec2-user
EOF
sed -i 's/vagrant/ec2-user/g' /mnt/gentoo/etc/sudoers

# Copy the existing ssh keys to to ec2-user so packer can continue
mkdir -p /mnt/gentoo/home/ec2-user/.ssh
cp /home/ec2-user/.ssh/authorized_keys /mnt/gentoo/home/ec2-user/.ssh/authorized_keys
$_CHROOT chmod -R 0700 /home/ec2-user/.ssh
$_CHROOT chmod -R 0600 /home/ec2-user/.ssh/authorized_keys
$_CHROOT chown -R ec2-user:ec2-user /home/ec2-user/.ssh

# Lock the root user and have the ami update the keys file on each boot
$_CHROOT passwd -l root
_EMERGE net-misc/curl
cat > /mnt/gentoo/etc/init.d/cloud-init << EOF
#!/sbin/runscript

depend() {
	need net
}

start() {
	curl http://169.254.169.254/latest/meta-data/public-keys/0/openssh-key > /home/ec2-user/.ssh/authorized_keys
}
EOF
$_CHROOT chmod +x /etc/init.d/cloud-init
$_CHROOT rc-update add cloud-init default

# Compile kernel based on Amazon Linux config
_EMERGE sys-kernel/gentoo-sources sys-kernel/genkernel
$_CHROOT /bin/bash << EOF
cp /boot/config-$(uname -r) /usr/src/linux/.config
cd /usr/src/linux
make olddefconfig
make --jobs=$_CORES
make modules_install
make install
genkernel initramfs
make clean
EOF
sed -i "s/Amazon Linux.*/Gentoo Linux $(date +"%Y.%m")/g" /boot/grub/menu.lst
sed -i "s/vmlinuz-$(uname -r)/vmlinuz-$(cat /mnt/gentoo/usr/src/linux/include/config/kernel.release)/g" /boot/grub/menu.lst
sed -i "s/initramfs-$(uname -r).img/initramfs-genkernel-x86_64-$(cat /mnt/gentoo/usr/src/linux/include/config/kernel.release)/g" /boot/grub/menu.lst

# Copy our chroot environment over our live environment
rsync --archive --delete --exclude /mnt \
	--exclude /mnt/gentoo/dev --exclude /dev \
	--exclude /mnt/gentoo/proc --exclude /proc \
	--exclude /mnt/gentoo/sys --exclude /sys \
	/mnt/gentoo/ /

# The previous command will have trashed the rootfs and init system so we need
# to sync the file system and force a reboot using some sysrq magic
sync && sync && sync
echo 1 > /proc/sys/kernel/sysrq
echo b > /proc/sysrq-trigger
