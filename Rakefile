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
      sh "vagrant up fake_managed_#{os}_server"
      sh "vagrant up my_#{os}_server --provider=managed"
      sh "vagrant provision my_#{os}_server"
      sh "vagrant reload my_#{os}_server"
    ensure
      sh "vagrant destroy -f my_#{os}_server"
      sh "vagrant destroy -f fake_managed_#{os}_server"
    end
  end
end
