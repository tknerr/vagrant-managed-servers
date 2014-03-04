source "https://rubygems.org"

gemspec

group :development do
  # We depend on Vagrant for development, but we don't add it as a
  # gem dependency because we expect to be installed within the
  # Vagrant environment itself using `vagrant plugin`.
  gem "vagrant", "1.4.3",
    :git => "https://github.com/mitchellh/vagrant.git",
    :ref => "v1.4.3"
  gem "vagrant-berkshelf", "1.4.0.dev1",
    :git => "https://github.com/berkshelf/vagrant-berkshelf.git",
    :ref => "28941db7c2f7d769b979c1d2695ac19b172a6542"
  gem "vagrant-omnibus", "1.3.0",
    :git => "https://github.com/tknerr/vagrant-omnibus.git",
    :branch => "cache-omnibus-download"
  gem "vagrant-cachier", "0.5.1"
end
