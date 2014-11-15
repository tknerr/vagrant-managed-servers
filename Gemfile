source "https://rubygems.org"

gemspec

group :development do
  # We depend on Vagrant for development, but we don't add it as a
  # gem dependency because we expect to be installed within the
  # Vagrant environment itself using `vagrant plugin`.
  gem "vagrant", "1.6.5",
    git: "https://github.com/mitchellh/vagrant.git",
    ref: "v1.6.5"
end

group :plugins do
  gem "vagrant-managed-servers", path: "."
  gem "vagrant-omnibus", "1.4.1"
  gem "vagrant-berkshelf", "3.0.1"
end