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
	:iso_file    => 'systemrescuecd-x86-4.3.0.iso',
	:iso_src     => 'http://downloads.sourceforge.net/project/systemrescuecd/sysresccd-x86/4.3.0/systemrescuecd-x86-4.3.0.iso',
	:iso_md5     => '228c7b86ed082a4f7357f5ac45be7a54',
	:iso_download_timeout => 10000,
	:boot_wait => '5',
	:boot_cmd_sequence => [
		'<Tab>',
		'<Backspace>' * 23,
		'setkmap=us rootpass=vagrant',
		'<Enter>'
	],
	:ssh_login_timeout => '10000',
	:ssh_user          => 'root',
	:ssh_password      => 'vagrant',
	:ssh_host_port     => '2222',
	:ssh_guest_port    => '22',
	:postinstall_files => genstall_files.sort_by { |f| File.basename(f) },
	:postinstall_timeout => 10000
})
