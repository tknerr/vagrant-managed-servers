require "log4r"
require "vagrant"

module VagrantPlugins
  module ManagedServers
    class Provider < Vagrant.plugin("2", :provider)
      def initialize(machine)
        @machine = machine
      end

      def action(name)
        # Attempt to get the action method from the Action class if it
        # exists, otherwise return nil to show that we don't support the
        # given action.
        action_method = "action_#{name}"
        return Action.send(action_method) if Action.respond_to?(action_method)
        nil
      end

      # Returns the SSH info for accessing the managed server.
      def ssh_info
        return {
          :host => @machine.provider_config.server,
          :port => 22
        }
      end

      def state

        # Run a custom action we define called "read_state" which does
        # what it says. It puts the state in the `:machine_state_id`
        # key in the environment.
        env = @machine.action("read_state")

        state_id = env[:machine_state_id]

        # Get the short and long description
        short = I18n.t("vagrant_managed_servers.states.short_#{state_id}")
        long  = I18n.t("vagrant_managed_servers.states.long_#{state_id}")

        # Return the MachineState object
        Vagrant::MachineState.new(state_id, short, long)
      end

      def to_s
        id = @machine.id.nil? ? "n/a" : @machine.id
        "ManagedServers (#{id})"
      end
    end
  end
end
