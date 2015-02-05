require "log4r"
require "timeout"
require "vagrant"

module VagrantPlugins
  module ManagedServers
    module Command
      # reboot the managed server
      class Reboot < Vagrant.plugin(2, :command)
        def self.synopsis
          'Reboots a Vagrant Managed Server instance'
        end

        def initialize(argv, env)
          super
          @env    = env
          @logger = Log4r::Logger.new("vagrant_managed_servers::action::reboot_server")
        end

        def execute()
          with_target_vms(nil, provider: :managed) do |machine|
            machine.action("reboot")
          end
        end
      end
    end
  end
end
