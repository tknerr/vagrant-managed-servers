# Vagrant ManagedServers Provider

This is a [Vagrant](http://www.vagrantup.com) 1.2+ plugin that adds a provider for "managed servers" to Vagrant, i.e. servers for which you have SSH access but no control over their lifecycle.

Since you don't control the lifecylce:
 * `up` and `destroy` are re-interpreted as "linking" / "unlinking" vagrant with a managed server
 * once "linked", the `ssh` and `provision` commands work as expected and `status` shows the managed server as either "running" or "not reachable"
 * `halt`, `destroy`, `reload` and `suspend` and `resume` are no-ops in this provider

Credits: this provider was initially based on the [vagrant-aws](https://github.com/mitchellh/vagrant-aws) provider with the AWS-specific functionality stripped out.

**NOTE:** This plugin requires Vagrant 1.2+

## Features

* SSH into managed servers.
* Provision managed servers with any built-in Vagrant provisioner.
* Minimal synced folder support via `rsync`.

## Usage

Install using standard Vagrant 1.1+ plugin installation methods. After installing, `vagrant up` and specify the `managed` provider. An example is shown below.

```
$ vagrant plugin install vagrant-managed-servers
...
$ vagrant up --provider=managed
$ vagrant provision
...
```

Of course prior to doing this, you'll need to obtain an managed server-compatible box file for Vagrant. Simply use the managed server dummy box for this purpose (see below).

## Quick Start

After installing the plugin (instructions above), the quickest way to get started is to actually use a managed server dummy box and specify the IP address / hostname of the managed server within a `config.vm.provider` block. So first, add the dummy box using any name you want:

```
$ vagrant box add dummy https://github.com/tknerr/vagrant-managed-servers/raw/master/dummy.box
...
```

And then make a Vagrantfile that looks like the following, filling in your information where necessary.

```
Vagrant.configure("2") do |config|
  config.vm.box = "dummy"

  config.vm.provider :managed do |managed, override|
    managed.server = "ip-or-hostname"
    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = "PATH TO YOUR PRIVATE KEY"
  end
end
```

Then run `vagrant up --provider=managed` to "link" vagrant with the managed server. 

Once linked, you can run `vagrant ssh` to ssh into the managed server or `vagrant provision` to provision that server with any of the available vagrant provisioners. 

If you are done, you can "unlink" vagrant from the managed server by running `vagrant destroy`.

If you try any of the other VM lifecycle commands like `halt`, `resume`, `reload`, etc... you will get a warning that these commands are not supported with the vagrant-managed-servers provider. 

## Box Format

Every provider in Vagrant must introduce a custom box format. 

This provider introduces `managed` box which is really nothing more than the required `metadata.json` with the provider name set to "managed".

Typically you will not need to change this and can always use the [dummy.box](https://github.com/tknerr/vagrant-managed-servers/raw/master/dummy.box)

## Configuration

This provider currently exposes only a single provider-specific configuration option:

* `server` - The IP address or hostname of the existing managed server

It can be set like typical provider-specific configuration:

```ruby
Vagrant.configure("2") do |config|
  # ... other stuff

  config.vm.provider :managed do |managed|
    managed.server = "some-server.org"
  end
end
```

## Networks

Networking features in the form of `config.vm.network` are not
supported with `vagrant-managed-servers`. If any of these are
specified, Vagrant will emit a warning and just ignore it.

## Synced Folders

There is minimal support for synced folders. Upon `vagrant provision`, 
the managed servers provider will use
`rsync` (if available) to uni-directionally sync the folder to
the remote machine over SSH.

This is good enough for all built-in Vagrant provisioners (shell,
chef, and puppet) to work!

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

First, fake a managed server by bringing up the `fake_managed_server` vagrant VM with the default virtualbox provider:

```
$ bundle exec vagrant up fake_managed_server
```

Now you can use the managed provider (defined in a separate VM named `my_server`) to ssh into or provision the (fake) managed server:

```
$ # link vagrant with the server
$ bundle exec vagrant up my_server --provider=managed
$ # ssh / provision
$ bundle exec vagrant ssh my_server
$ bundle exec vagrant provision my_server
$ # unlink
$ bundle exec vagrant destroy my_server
```
