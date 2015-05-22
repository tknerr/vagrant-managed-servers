source "https://rubygems.org"

gemspec

group :development do
  # We depend on Vagrant for development, but we don't add it as a
  # gem dependency because we expect to be installed within the
  # Vagrant environment itself using `vagrant plugin`.
  gem "vagrant", git: "https://github.com/mitchellh/vagrant.git", ref: "v1.7.2"
end

group :plugins do
  gem "vagrant-managed-servers", path: "."
  gem "vagrant-omnibus", "1.4.1"
  gem "vagrant-berkshelf", "4.0.4"
  gem "vagrant-winrm-syncedfolders"
end
