require "vagrant"

module VagrantPlugins
  module ManagedServers
    class Config < Vagrant.plugin("2", :config)
      
      # The IP address or hostname of the managed server.
      #
      # @return [String]
      attr_accessor :server

      def initialize()
        @server      = UNSET_VALUE
      end

      def finalize!
        # server must be nil, since we can't default that
        @server = nil if @server == UNSET_VALUE
      end

      def validate(machine)
        errors = _detected_errors
        errors << I18n.t("vagrant_managed_servers.config.server_required") if @server.nil?
        { "ManagedServers Provider" => errors }
      end
    end
  end
end
