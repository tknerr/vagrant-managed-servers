# Vagrant ManagedServers Provider

[![Build Status](https://travis-ci.org/tknerr/vagrant-managed-servers.png?branch=master)](https://travis-ci.org/tknerr/vagrant-managed-servers)

This is a [Vagrant](http://www.vagrantup.com) 1.6+ plugin that adds a provider for "managed servers" to Vagrant, i.e. servers for which you have SSH access but no control over their lifecycle.

Since you don't control the lifecycle:
 * `up` and `destroy` are re-interpreted as "linking" / "unlinking" vagrant with a managed server
 * once "linked", the `ssh` and `provision` commands work as expected and `status` shows the managed server as either "running" or "not reachable"
 * `reload` will issue a reboot command on the managed server (cross your fingers ;-))
 * `halt`, `suspend` and `resume` are no-ops in this provider

Credits: this provider was initially based on the [vagrant-aws](https://github.com/mitchellh/vagrant-aws) provider with the AWS-specific functionality stripped out.

## Features

* SSH into managed servers.
* Provision managed servers with any built-in Vagrant provisioner.
* Reboot a managed server.
* Synced folder support.

## Usage

Install using the standard Vagrant plugin installation method:
```
$ vagrant plugin install vagrant-managed-servers
```

In the Vagrantfile you can now use the `managed` provider and specify the managed server's hostname and credentials:
```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "tknerr/managed-server-dummy"

  config.vm.provider :managed do |managed, override|
    managed.server = "foo.acme.com"
    override.ssh.username = "bob"
    override.ssh.private_key_path = "/path/to/bobs_private_key"
  end
end
```

Next run `vagrant up --provider=managed` in order to "link" the vagrant VM with the managed server:
```
$ vagrant up --provider=managed
Bringing machine 'default' up with 'managed' provider...
==> default: Box 'tknerr/managed-server-dummy' could not be found. Attempting to find and install...
    default: Box Provider: managed
    default: Box Version: >= 0
==> default: Loading metadata for box 'tknerr/managed-server-dummy'
    default: URL: https://vagrantcloud.com/tknerr/managed-server-dummy
==> default: Adding box 'tknerr/managed-server-dummy' (v1.0.0) for provider: managed
    default: Downloading: https://vagrantcloud.com/tknerr/managed-server-dummy/version/1/provider/managed.box
    default: Progress: 100% (Rate: 122k/s, Estimated time remaining: --:--:--)
==> default: Successfully added box 'tknerr/managed-server-dummy' (v1.0.0) for 'managed'!
==> default: Linking vagrant with managed server foo.acme.com
==> default:  -- Server: foo.acme.com
```

Once linked, you can run `vagrant ssh` to ssh into the managed server or `vagrant provision` to provision that server with any of the available vagrant provisioners:
```
$ vagrant provision
...
$ vagrant ssh
...
```

In some cases you might need to reboot the managed server via `vagrant reload`:
```
$ vagrant reload
==> default: Rebooting managed server foo.acme.com
==> default:  -- Server: foo.acme.com
==> default: Waiting for foo.acme.com to reboot
==> default: Waiting for foo.acme.com to reboot
==> default: Waiting for foo.acme.com to reboot
==> default:  foo.acme.com rebooted and ready.
```

If you are done, you can "unlink" vagrant from the managed server by running `vagrant destroy`:
```
$ vagrant destroy -f
==> default: Unlinking vagrant from managed server foo.acme.com
==> default:  -- Server: foo.acme.com
```

If you try any of the other VM lifecycle commands like `halt`, `suspend`, `resume`, etc... you will get a warning that these commands are not supported with the vagrant-managed-servers provider.

## Box Format

Every provider in Vagrant must introduce a custom box format. This provider introduces a "dummy box" for the `managed` provider which is really nothing more than the required `metadata.json` with the provider name set to "managed".

You can use the [tknerr/managed-server-dummy](https://atlas.hashicorp.com/tknerr/boxes/managed-server-dummy) box like that:
```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "tknerr/managed-server-dummy"
  ...
end
```

## Configuration

This provider currently exposes only a single provider-specific configuration option:

* `server` - The IP address or hostname of the existing managed server

It can be set like typical provider-specific configuration:

```ruby
Vagrant.configure("2") do |config|
  # ... other stuff

  config.vm.provider :managed do |managed|
    managed.server = "myserver.mydomain.com"
  end
end
```

## Networks

Networking features in the form of `config.vm.network` are not
supported with `vagrant-managed-servers`. If any of these are
specified, Vagrant will emit a warning and just ignore it.

## Synced Folders

There is minimal synced folders support for provisioning linux guests
via rsync, and for windows guests via either smb, winrm or rsync
([see below](https://github.com/tknerr/vagrant-managed-servers#synced-folders-windows)).

This is good enough for all built-in Vagrant provisioners (shell,
chef, and puppet) to work!

## Windows support
It is possible to use this plugin to control pre-existing windows servers using
WinRM instead of rsync, with a few prerequisites:

* WinRM installed and running on the target machine
* The account used to connect is a local account and also a local administrator (domain accounts don't work over basic auth)
* WinRM basic authentication is enabled
* WinRM unencrypted traffic is enabled

For more information, see the WinRM Gem [Troubleshooting Guide](https://github.com/WinRb/WinRM#troubleshooting)

Your vagrantfile will look something like this:
```ruby
config.vm.define 'my-windows-server' do |windows|
  windows.vm.communicator = :winrm
  windows.winrm.username = 'vagrant'
  windows.winrm.password = 'vagrant'
  windows.vm.provider :managed do |managed, override|
    managed.server = 'myserver.mydomain.com'
  end
end
```

### Synced Folders (Windows)
Vagrant Managed Servers will try several different mechanisms to sync folders for Windows guests. In order of priority:

1. [SMB](http://docs.vagrantup.com/v2/synced-folders/smb.html) - requires running from a Windows host, an Administrative console, and Powershell 3 or greater. Note that there is a known [bug](https://github.com/mitchellh/vagrant/issues/3139) which causes the Powershell version check to hang for Powershell 2
2. [WinRM](https://github.com/cimpress-mcp/vagrant-winrm-syncedfolders) - uses the WinRM communicator and is reliable, but can be slow for large numbers of files.
3. [RSync](http://docs.vagrantup.com/v2/synced-folders/rsync.html) - requires `rsync.exe` installed and on your path.

Vagrant will try to use the best folder synchronization mechanism given your host and guest capabilities, but you can force a different type of folder sync with the `type` parameter of the `synced_folder` property in your Vagrantfile.

```ruby
windows.vm.synced_folder '.', '/vagrant', type: "winrm"
```

## Development

To work on the `vagrant-managed-servers` plugin, clone this repository out, and use
[Bundler](http://gembundler.com) to get the dependencies:

```
$ bundle
```

Once you have the dependencies, verify the unit tests pass with `rake`:

```
$ bundle exec rake
```

If those pass, you're ready to start developing the plugin. You can test
the plugin without installing it into your Vagrant environment by using the
`Vagrantfile` in the top level of this directory and use bundler to execute Vagrant.

First, let's pretend we have a managed server by bringing up the `local_linux` vagrant VM with the default virtualbox provider:

```
$ bundle exec vagrant up local_linux
```

Now you can use the managed provider (defined in a separate VM named `managed_linux`) to ssh into or provision the actual managed server:

```
$ # link vagrant with the server
$ bundle exec vagrant up managed_linux --provider=managed
$ # ssh / provision
$ bundle exec vagrant ssh managed_linux
$ bundle exec vagrant provision managed_linux
$ # unlink
$ bundle exec vagrant destroy managed_linux
```
