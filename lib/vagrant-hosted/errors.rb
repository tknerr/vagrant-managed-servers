require "vagrant"

module VagrantPlugins
  module Hosted
    module Errors
      class VagrantHostedError < Vagrant::Errors::VagrantError
        error_namespace("vagrant_hosted.errors")
      end

      class HostedServerNotReachable < VagrantHostedError
        error_key(:server_not_reachable)
      end

      class RsyncError < VagrantHostedError
        error_key(:rsync_error)
      end
    end
  end
end
