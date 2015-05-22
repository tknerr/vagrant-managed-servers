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
  ['linux', 'windows'].each do |os|
    begin
      sh "vagrant up local_#{os}"
      sh "vagrant up managed_#{os} --provider=managed"
      sh "vagrant provision managed_#{os}"
      sh "vagrant reload managed_#{os}"
    ensure
      sh "vagrant destroy -f managed_#{os}"
      sh "vagrant destroy -f local_#{os}"
    end
  end
end
