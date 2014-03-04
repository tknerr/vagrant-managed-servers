# -*- mode: ruby -*-
# vi: set ft=ruby :

# require plugin for testing via bundler
Vagrant.require_plugin "vagrant-managed-servers"
Vagrant.require_plugin "vagrant-omnibus"
Vagrant.require_plugin "vagrant-berkshelf"
Vagrant.require_plugin "vagrant-cachier"

Vagrant.configure("2") do |config|

  ENV['OMNIBUS_INSTALL_URL'] = "https://gist.githubusercontent.com/tknerr/9205663/raw/install.sh"
  config.omnibus.chef_version = "11.10.4"
  config.berkshelf.enabled = true
  config.cache.auto_detect = true

  #
  # fake a managed server by bringing up a virtualbox vm
  #
  config.vm.define :fake_managed_server do |fms_config|
    fms_config.vm.box = "opscode_ubuntu-13.04_provisionerless"
    fms_config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-13.04_provisionerless.box"
  
    fms_config.vm.network :private_network, ip: "33.33.77.35"
  end

  #
  # configure managed provider to connect to `fake_managed_server`
  #
  config.vm.define :my_server do |ms_config|

    ms_config.vm.box = "dummy"
    ms_config.vm.box_url = "https://github.com/tknerr/vagrant-managed-servers/raw/master/dummy.box"
  
    ms_config.vm.provider :managed do |managed_config, override|
      managed_config.server = "33.33.77.35"
      override.ssh.username = "vagrant"
      override.ssh.private_key_path = "#{ENV['HOME']}/.vagrant.d/insecure_private_key"
    end

    ms_config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = [ './cookbooks' ]
      chef.add_recipe "apt"
      chef.add_recipe "apache2"
    end
  end

end
