
# Changelog

## 0.8.0 (unreleased)

* ...

## 0.7.1 (released 2015-05-22)

* fix bug where the vagrant-winrm-syncedfolders plugin dependency is not properly loaded (see [#49](https://github.com/tknerr/vagrant-managed-servers/issues/49), thanks @chrisbaldauf for the fix!)

## 0.7.0 (released 2015-05-22)

* extract the WinRM synced folder mechanism into [a separate plugin](https://github.com/Cimpress-MCP/vagrant-winrm-syncedfolders) (see [#47](https://github.com/tknerr/vagrant-managed-servers/pull/47), thanks @chrisbaldauf!)
* use the `Vagrant::Action::Builtin::SyncedFolders` for provisioning windows guests. This will use (the much faster) SMB synced folders if possible (see [README](https://github.com/tknerr/vagrant-managed-servers#synced-folders-windows)), otherwise fall back to the WinRM implementation above (see [#46](https://github.com/tknerr/vagrant-managed-servers/issues/46), thanks @chrisbaldauf!)
* clean up the example Vagrantfile and add windows examples [#48](https://github.com/tknerr/vagrant-managed-servers/pull/48)

## 0.6.2 (released 2015-04-30)

* fix bug where WinRM file sync fails occasionally (retry 3 times) ([#43](https://github.com/tknerr/vagrant-managed-servers/issues/43), thanks @chrisbaldauf!)
* fix bug where only the first folder is synced on Windows ([#44](https://github.com/tknerr/vagrant-managed-servers/issues/44), thanks @chrisbaldauf!)

## 0.6.1 (released 2015-04-02)

* quote ssh usernames to support active directory style `domain/user` logins ([#38](https://github.com/tknerr/vagrant-managed-servers/issues/38), thanks @chrisbaldauf!)
* document / validate vagrant 1.6+ compatibility which is required for winrm ([#40](https://github.com/tknerr/vagrant-managed-servers/issues/40), thanks @LiamK for reporting!)

## 0.6.0 (released 2015-03-16)

* add missing translation for `vagrant status` ([#35](https://github.com/tknerr/vagrant-managed-servers/issues/35), thanks @warrenseine for reporting!)
* actually check whether a server is linked before doing any other action (fixes [#34](https://github.com/tknerr/vagrant-managed-servers/issues/34), thanks @warrenseine for reporting!)
* fix the annoying network configuration warning so that it's shown only when necessary ([#37](https://github.com/tknerr/vagrant-managed-servers/pull/37))

## 0.5.1 (released 2015-02-15)

* fix bug where `vagrant help` failed due a leftover command declaration ([#32](https://github.com/tknerr/vagrant-managed-servers/pull/32), thanks @chrisbaldauf for reporting!)

## 0.5.0 (released 2015-02-08)

* add `reload` functionality ([#31](https://github.com/tknerr/vagrant-managed-servers/pull/31), thanks @jdaviscooke!)

## 0.4.1 (released 2014-11-17)

* fix missing parameters in translation for winrm ([#30](https://github.com/tknerr/vagrant-managed-servers/pull/30), thanks @chrisbaldauf!)
* clean up Rakefile and fix travis-ci build

## 0.4.0 (released 2014-11-15)

* update licensing information and add license to gemspec
* add support for windows managed servers via winrm ([#29](https://github.com/tknerr/vagrant-managed-servers/pull/29), thanks @chrisbaldauf!)

## 0.3.0 (released 2014-08-23)

Updates for improving the experience with Vagrant 1.5+ (but still keeping backwards-compatibility with 1.2):

* fix warning when using Vagrant > 1.5 ([#19](https://github.com/tknerr/vagrant-managed-servers/issues/19), thanks @nicolasbrechet!)
* use the [tknerr/managed-server-dummy](https://vagrantcloud.com/tknerr/managed-server-dummy) vagrantcloud box ([#22](https://github.com/tknerr/vagrant-managed-servers/pull/22))
* updated the development environment and sample Vagrantfile for this project to latest Vagrant and plugin versions

## 0.2.0 (released 2014-02-26)

* fix rsync command for Vagrant 1.4 compatibility ([#15](https://github.com/tknerr/vagrant-managed-servers/issues/15))
* chown synced dirs recursively ([#13](https://github.com/tknerr/vagrant-managed-servers/issues/13))
* minor README fixes ([#11](https://github.com/tknerr/vagrant-managed-servers/issues/11), [#12](https://github.com/tknerr/vagrant-managed-servers/issues/12), [#16](https://github.com/tknerr/vagrant-managed-servers/issues/16))

## 0.1.0 (released 2013-06-10)

* Initial release
