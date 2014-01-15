task :clean do
	FileUtils.rm('Vagrantfile') if File.exist?('Vagrantfile')
	FileUtils.rm('gentoo-amd64.box') if File.exist?('gentoo-amd64.box')

	system('VBoxManage showvminfo gentoo-amd64 > /dev/null 2>&1')
	if $?.exitstatus == 0
		system('VBoxManage list runningvms | grep gentoo-amd64 > /dev/null 2>&1')
		if $?.exitstatus == 0
			system('VBoxManage controlvm gentoo-amd64 poweroff')
		end
		system('VBoxManage unregistervm --delete gentoo-amd64')
	end
	
	system('vagrant box list | grep gentoo-amd64 > /dev/null 2>&1')
	if $?.exitstatus == 0
		system('vagrant box remove gentoo-amd64')
	end
end

task :veewee_build do
	system('veewee vbox build gentoo-amd64 --auto --nogui')
end

task :veewee_export do
	system('VBoxManage list runningvms | grep gentoo-amd64 > /dev/null 2>&1')
	while $?.exitstatus == 0 do
		sleep 5
		system('VBoxManage list runningvms | grep gentoo-amd64 > /dev/null 2>&1')
	end
	system('veewee vbox export gentoo-amd64')
end

task :vagrant_import do
	system('vagrant box add gentoo-amd64 gentoo-amd64.box')
	system('vagrant init gentoo-amd64')
end

task :build => [:clean, :veewee_build, :veewee_export, :vagrant_import]
