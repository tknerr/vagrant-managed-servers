# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  #
  # fake a managed linux server by bringing up a virtualbox vm
  #
  config.vm.define :fake_managed_linux_server do |fms_config|
    fms_config.vm.box = "chef/ubuntu-12.04-i386"
    fms_config.vm.network :private_network, ip: "192.168.40.35"
    fms_config.berkshelf.enabled = false
  end

  #
  # configure managed provider to connect to `fake_managed_linux_server`
  #
  config.vm.define :my_linux_server do |ms_config|

    ms_config.vm.box = "tknerr/managed-server-dummy"

    ms_config.omnibus.chef_version = "12.0.3"
    ms_config.berkshelf.enabled = true

    ms_config.vm.provider :managed do |managed_config, override|
      managed_config.server = "192.168.40.35"
      override.ssh.username = "vagrant"
      override.ssh.private_key_path = ".vagrant/machines/fake_managed_linux_server/virtualbox/private_key"
    end

    ms_config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = [ './cookbooks' ]
      chef.add_recipe "apt"
      chef.add_recipe "apache2"
    end
  end



  #
  # fake a managed windows server by bringing up a virtualbox vm
  #
  config.vm.define :fake_managed_windows_server do |fms_config|
    fms_config.vm.box = "boxcutter/eval-win7x86-enterprise"
    fms_config.vm.network :private_network, ip: "192.168.40.36"
    fms_config.berkshelf.enabled = false
  end

  #
  # configure managed provider to connect to `fake_managed_windows_server`
  #
  config.vm.define :my_windows_server do |ms_config|

    ms_config.vm.box = "tknerr/managed-server-dummy"

    ms_config.berkshelf.enabled = false

    ms_config.vm.communicator = :winrm
    ms_config.winrm.username = 'vagrant'
    ms_config.winrm.password = 'vagrant'

    ms_config.vm.provider :managed do |managed, override|
      managed.server = '192.168.40.36'
    end
  end

end
