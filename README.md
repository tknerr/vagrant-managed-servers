# Vagrant Hosted Provider

This is a [Vagrant](http://www.vagrantup.com) 1.2+ plugin that adds a provider for "hosted servers" to Vagrant, i.e. servers for which you have SSH access but no control over their lifecycle.

Since you don't control the lifecylce:
 * `up`, `halt`, `destroy`, `suspend` and `resume` are no-ops in this provider
 * `ssh`, `provision` and `reload` work as expected 


**NOTE:** This plugin requires Vagrant 1.2+,

## Features

* SSH into hosted servers.
* Provision hosted servers with any built-in Vagrant provisioner.
* Minimal synced folder support via `rsync`.

## Usage

Install using standard Vagrant 1.1+ plugin installation methods. After installing, `vagrant up` and specify the `hosted` provider. An example is shown below.

```
$ vagrant plugin install vagrant-hosted
...
$ vagrant up --provider=hosted
...
```

Of course prior to doing this, you'll need to obtain an hosted server-compatible box file for Vagrant. Simply use the hosted server dummy box for this purpose (see below).

## Quick Start

After installing the plugin (instructions above), the quickest way to get started is to actually use a hosted server dummy box and specify the IP address / hostname of the hosted server within a `config.vm.provider` block. So first, add the dummy box using any name you want:

```
$ vagrant box add dummy https://github.com/tknerr/vagrant-hosted/raw/master/dummy.box
...
```

And then make a Vagrantfile that looks like the following, filling in your information where necessary.

```
Vagrant.configure("2") do |config|
  config.vm.box = "dummy"

  config.vm.provider :hosted do |hosted, override|
    hosted.server = "ip-or-hostname"
    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = "PATH TO YOUR PRIVATE KEY"
  end
end
```

Then run `vagrant ssh --provider=hosted` ssh into the hosted server.

Similarly you can run `vagrant provision --provider=hosted` to provision that server with any of the available vagrant provisioners. 

If you try any of the VM lifecycle commands like `up`, `destroy`, etc... you will get a warning that these commands are not supported with the vagrant-hosted provider. 

## Box Format

Every provider in Vagrant must introduce a custom box format. 

This provider introduces `hosted` box which is really nothing more than the required `metadata.json` with the provider name set to "hosted".

Typically you will not need to change this and can always use the [dummy.box](https://github.com/tknerr/vagrant-hosted/raw/master/dummy.box)

## Configuration

This provider currently exposes only a single provider-specific configuration option:

* `server` - The IP address or hostname of the existing hosted server

It can be set like typical provider-specific configuration:

```ruby
Vagrant.configure("2") do |config|
  # ... other stuff

  config.vm.provider :hosted do |hosted|
    hosted.server = "some-server.org"
  end
end
```

## Networks

Networking features in the form of `config.vm.network` are not
supported with `vagrant-hosted`. If any of these are
specified, Vagrant will emit a warning and just ignore it.

## Synced Folders

There is minimal support for synced folders. Upon `vagrant provision`, 
the hosted servers provider will use
`rsync` (if available) to uni-directionally sync the folder to
the remote machine over SSH.

This is good enough for all built-in Vagrant provisioners (shell,
chef, and puppet) to work!

## Development

To work on the `vagrant-hosted` plugin, clone this repository out, and use
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

First, fake a hosted server by bringing up the `fake_hosted_server` vagrant VM with the default virtualbox provider:

```
$ bundle exec vagrant up fake_hosted_server
```

Now you can use the hosted provider (defined in a separate VM named `my_server`) to ssh into or provision the (fake) hosted server:

```
$ bundle exec vagrant ssh my_server --provider=hosted
$ bundle exec vagrant provision my_server --provider=hosted
```
