Vagrant.configure("2") do |config|
	config.vm.box = "fgrehm/trusty64-lxc"
	config.vm.synced_folder "salt/", "/srv/salt"
	config.vm.synced_folder "pillar/", "/srv/pillar"
	config.vm.provision :salt do |salt|
		salt.minion_config = "minion"
		salt.run_highstate = false
    end

    config.vm.provision :shell do |shell|
        shell.inline = "salt-call state.highstate pillar='{domain_name: localhost, setup: rails, project_name: railstest, sudouser: vagrant}'"
	end
end

Vagrant::Config.run do |config|
  config.vm.forward_port 80, 8006
end

