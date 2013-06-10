require "vagrant"

module VagrantPlugins
  module ManagedServers
    module Errors
      class VagrantManagedServersError < Vagrant::Errors::VagrantError
        error_namespace("vagrant_managed_servers.errors")
      end

      class ManagedServersServerNotReachable < VagrantManagedServersError
        error_key(:server_not_reachable)
      end

      class RsyncError < VagrantManagedServersError
        error_key(:rsync_error)
      end
    end
  end
end
