# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  #
  # fake a managed server by bringing up a virtualbox vm
  #
  config.vm.define :fake_managed_server do |fms_config|
    fms_config.vm.box = "chef/ubuntu-12.04-i386"
    fms_config.vm.network :private_network, ip: "192.168.40.35"
  end

  #
  # configure managed provider to connect to `fake_managed_server`
  #
  config.vm.define :my_server do |ms_config|

    ms_config.vm.box = "dummy"
    ms_config.vm.box_url = "https://github.com/tknerr/vagrant-managed-servers/raw/master/dummy.box"

    ms_config.omnibus.chef_version = "11.14.6"
    ms_config.berkshelf.enabled = true
  
    ms_config.vm.provider :managed do |managed_config, override|
      managed_config.server = "192.168.40.35"
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
