require 'net/http'

template_uri   = 'http://distfiles.gentoo.org/releases/amd64/autobuilds/latest-install-amd64-minimal.txt'
template_build = Net::HTTP.get_response(URI.parse(template_uri)).body
template_build = /^(([^#].*)\/(.*))/.match(template_build)

genstall_files = Dir.glob('../../genstall.d/*.sh')
veewee_files = Dir.glob('*.sh')
genstall_files.concat(veewee_files)

Veewee::Definition.declare({
	:cpu_count   => 2,
	:memory_size => '512',
	:disk_size   => '40960',
	:disk_format => 'VDI',
	:hostiocache => 'off',
	:os_type_id  => 'Gentoo_64',
	:iso_file    => template_build[3],
	:iso_src     => "http://distfiles.gentoo.org/releases/amd64/autobuilds/#{template_build[1]}",
	:iso_download_timeout => 10000,
	:boot_wait => "5",
	:boot_cmd_sequence => [
		'gentoo-nofb<Enter>',
		'<Wait>' * 60,
		'passwd<Enter><Wait>',
		'vagrant<Enter><Wait>',
		'vagrant<Enter><Wait>',
		'/etc/init.d/sshd start<Enter>'
	],
	:ssh_login_timeout => '10000',
	:ssh_user          => 'root',
	:ssh_password      => 'vagrant',
	:ssh_host_port     => '2222',
	:ssh_guest_port    => '22',
	:postinstall_files => genstall_files.sort_by { |f| File.basename(f) },
	:postinstall_timeout => 10000
})
