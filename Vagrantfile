# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  #
  # fake a managed linux server by bringing up a virtualbox vm
  #
  config.vm.define :local_linux do |ll_config|
    ll_config.vm.box = "chef/ubuntu-12.04-i386"
    ll_config.vm.network :private_network, ip: "192.168.40.35"
    ll_config.berkshelf.enabled = false
    ll_config.vm.synced_folder ".", "/vagrant", disabled: true
  end

  #
  # configure managed provider to connect to `local_linux`
  #
  config.vm.define :managed_linux do |ml_config|

    ml_config.vm.box = "tknerr/managed-server-dummy"

    ml_config.omnibus.chef_version = "12.0.3"
    ml_config.berkshelf.enabled = true

    ml_config.vm.provider :managed do |managed_config, override|
      managed_config.server = "192.168.40.35"
      override.ssh.username = "vagrant"
      override.ssh.private_key_path = ".vagrant/machines/local_linux/virtualbox/private_key"
    end

    ml_config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = [ './cookbooks' ]
      chef.add_recipe "apt"
      chef.add_recipe "apache2"
    end
  end



  #
  # fake a managed windows server by bringing up a virtualbox vm
  #
  config.vm.define :local_windows do |lw_config|
    lw_config.vm.box = "boxcutter/eval-win7x86-enterprise"
    lw_config.vm.network :private_network, ip: "192.168.40.36"
    lw_config.berkshelf.enabled = false
    lw_config.vm.synced_folder ".", "/vagrant", disabled: true
  end

  #
  # configure managed provider to connect to `local_windows`
  #
  config.vm.define :managed_windows do |mw_config|

    mw_config.vm.box = "tknerr/managed-server-dummy"

    mw_config.berkshelf.enabled = false

    mw_config.vm.communicator = :winrm
    mw_config.winrm.username = 'vagrant'
    mw_config.winrm.password = 'vagrant'

    mw_config.vm.provider :managed do |managed, override|
      managed.server = '192.168.40.36'
    end
  end

end
