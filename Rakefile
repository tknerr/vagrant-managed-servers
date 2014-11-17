require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = [].tap do |a|
    a.push('--color')
    a.push('--format doc')
  end.join(' ')
end

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
