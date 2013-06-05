require "vagrant"

module VagrantPlugins
  module Hosted
    class Config < Vagrant.plugin("2", :config)
      
      # The IP address or hostname of the hosted server.
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
        errors << I18n.t("vagrant_hosted.config.server_required") if @server.nil?
        { "Hosted Provider" => errors }
      end
    end
  end
end
