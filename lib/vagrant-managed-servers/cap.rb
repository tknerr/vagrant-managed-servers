module VagrantPlugins
  module ManagedServers
    module Cap
      # Returns guest's IP address that can be used to access the VM from the
      # host machine.
      #
      # @return [String] Guest's IP address
      def self.public_address(machine)
        return nil if machine.state.id != :running

        ssh_info = machine.ssh_info
        return nil if !ssh_info
        ssh_info[:host]
      end
    end
  end
end
