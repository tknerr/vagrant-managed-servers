source "https://rubygems.org"

gemspec

group :development do
  # We depend on Vagrant for development, but we don't add it as a
  # gem dependency because we expect to be installed within the
  # Vagrant environment itself using `vagrant plugin`.
  gem "vagrant", :git => "git://github.com/mitchellh/vagrant.git", :ref => "v1.2.2"
  gem "berkshelf", "2.0.1"
  gem "vagrant-omnibus", "1.0.2"
end
