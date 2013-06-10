# -*- mode: ruby -*-
# vi: set ft=ruby :

# require plugin for testing via bundler
Vagrant.require_plugin "vagrant-hosted"
Vagrant.require_plugin "vagrant-omnibus"

Vagrant.configure("2") do |config|

  config.omnibus.chef_version = "11.4.4"
    

  #
  # fake a hosted server by bringing up a virtualbox vm
  #
  config.vm.define :fake_hosted_server do |fhs_config|
    fhs_config.vm.box = "opscode_ubuntu-13.04_provisionerless"
    fhs_config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-13.04_provisionerless.box"
  
    fhs_config.vm.network :private_network, ip: "33.33.77.35"
  end

  #
  # configure hosted provider to connect to `fake_hosted_server`
  #
  config.vm.define :my_server do |ms_config|

    ms_config.vm.box = "dummy"
    ms_config.vm.box_url = "https://github.com/tknerr/vagrant-hosted/raw/master/dummy.box"
  
    ms_config.vm.provider :hosted do |hosted_config, override|
      hosted_config.server = "33.33.77.35"
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
