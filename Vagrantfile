Vagrant.configure("2") do |config|
	config.vm.box = "saucy64"
	config.vm.synced_folder "salt/", "/srv/dl-salt/salt"
	config.vm.synced_folder "pillar/", "/srv/dl-salt/pillar"
	config.vm.provision :salt do |salt|
		salt.minion_config = "minion"
		salt.run_highstate = false
	end
end

Vagrant::Config.run do |config|
  config.vm.forward_port 80, 8006
end

