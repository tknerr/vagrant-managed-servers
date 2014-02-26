require 'rubygems'
require 'bundler/setup'
require 'rspec/core/rake_task'

# Immediately sync all stdout so that tools like buildbot can
# immediately load in the output.
$stdout.sync = true
$stderr.sync = true

# Change to the directory of this file.
Dir.chdir(File.expand_path("../", __FILE__))

# This installs the tasks that help with gem creation and
# publishing.
Bundler::GemHelper.install_tasks

# Install the `spec` task so that we can run tests.
RSpec::Core::RakeTask.new

# Default task is to run the unit tests
task :default => "spec"

desc "runs the acceptance \"test\" as described in README"
task :acceptance do
  begin
    sh "vagrant up fake_managed_server"
    sh "vagrant up my_server --provider=managed"
    sh "vagrant provision my_server"
  ensure
    sh "vagrant destroy -f"
  end
end
