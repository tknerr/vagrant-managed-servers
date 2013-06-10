require "pathname"

require "vagrant/action/builder"

module VagrantPlugins
  module Hosted
    module Action
      # Include the built-in modules so we can use them as top-level things.
      include Vagrant::Action::Builtin
      
      # This action is called to establish linkage between vagrant and the managed server
      def self.action_up
        Vagrant::Action::Builder.new.tap do |b|
          b.use HandleBoxUrl
          b.use ConfigValidate
          b.use WarnNetworks
          b.use LinkServer
=begin
          b.use HandleBoxUrl
          b.use ConfigValidate
          b.use Call, IsReachable do |env, b2|
            if env[:result]
              b2.use !MessageNotReachable
              next
            end

            b2.use Provision
            b2.use SyncFolders
            b2.use WarnNetworks
            b2.use LinkServer
          end
=end
        end
      end

      # This action is called to "unlink" vagrant from the managed server
      def self.action_destroy
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use UnlinkServer
        end
      end

      # This action is called when `vagrant provision` is called.
      def self.action_provision
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use WarnNetworks
          b.use Call, IsReachable do |env, b2|
            if !env[:result]
              b2.use MessageNotReachable
              next
            end

            b2.use Provision
            b2.use SyncFolders
          end
        end
      end

      # This action is called to read the state of the machine. The
      # resulting state is expected to be put into the `:machine_state_id`
      # key.
      def self.action_read_state
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use ReadState
        end
      end

      # This action is called to SSH into the machine.
      def self.action_ssh
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use WarnNetworks
          b.use Call, IsReachable do |env, b2|
            if !env[:result]
              b2.use MessageNotReachable
              next
            end

            b2.use SSHExec
          end
        end
      end

      def self.action_ssh_run
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use WarnNetworks
          b.use Call, IsReachable do |env, b2|
            if !env[:result]
              b2.use MessageNotReachable
              next
            end

            b2.use SSHRun
          end
        end
      end


      # The autoload farm
      action_root = Pathname.new(File.expand_path("../action", __FILE__))
      autoload :IsReachable, action_root.join("is_reachable")
      autoload :MessageNotReachable, action_root.join("message_not_reachable")
      autoload :ReadState, action_root.join("read_state")
      autoload :SyncFolders, action_root.join("sync_folders")
      autoload :WarnNetworks, action_root.join("warn_networks")
      autoload :LinkServer, action_root.join("link_server")
      autoload :UnlinkServer, action_root.join("unlink_server")
    end
  end
end
