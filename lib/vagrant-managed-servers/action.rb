require "pathname"

require "vagrant/action/builder"

module VagrantPlugins
  module ManagedServers
    module Action
      # Include the built-in modules so we can use them as top-level things.
      include Vagrant::Action::Builtin

      # This action is called to establish linkage between vagrant and the managed server
      def self.action_up
        Vagrant::Action::Builder.new.tap do |b|
          if Vagrant::VERSION < '1.5.0'
            b.use HandleBoxUrl
          else
            b.use HandleBox
          end
          b.use ConfigValidate
          b.use WarnNetworks
          b.use Call, IsLinked do |env, b2|
            if env[:result]
              b2.use MessageAlreadyLinked
              next
            end

            b2.use LinkServer
          end
        end
      end

      # This action is called to "unlink" vagrant from the managed server
      def self.action_destroy
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsLinked do |env, b2|
            if !env[:result]
              b2.use MessageNotLinked
              next
            end

            b2.use UnlinkServer
          end
        end
      end

      # This action is called when `vagrant provision` is called.
      def self.action_provision
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use WarnNetworks
          b.use Call, IsLinked do |env, b2|
            if !env[:result]
              b2.use MessageNotLinked
              next
            end

            b2.use Call, IsReachable do |env, b3|
              if !env[:result]
                b3.use MessageNotReachable
                next
              end

              b3.use Provision
              if env[:machine].config.vm.communicator == :winrm
                # Use the builtin vagrant folder sync for Windows target servers.
                # This gives us SMB folder sharing, which is much faster than the
                # WinRM uploader for any non-trivial number of files.
                b3.use Vagrant::Action::Builtin::SyncedFolders
              else
                # Vagrant managed servers custom implementation
                b3.use SyncFolders
              end
            end
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
          b.use Call, IsLinked do |env, b2|
            if !env[:result]
              b2.use MessageNotLinked
              next
            end

            b2.use Call, IsReachable do |env, b3|
              if !env[:result]
                b3.use MessageNotReachable
                next
              end

              b3.use SSHExec
            end
          end
        end
      end

      def self.action_ssh_run
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use WarnNetworks
          b.use Call, IsLinked do |env, b2|
            if !env[:result]
              b2.use MessageNotLinked
              next
            end

            b2.use Call, IsReachable do |env, b3|
              if !env[:result]
                b3.use MessageNotReachable
                next
              end

              b3.use SSHRun
            end
          end
        end
      end

      def self.action_reload
        Vagrant::Action::Builder.new.tap do |b|
          b.use Call, IsLinked do |env, b2|
            if !env[:result]
              b2.use MessageNotLinked
              next
            end

            b2.use RebootServer
          end
        end
      end

      # The autoload farm
      action_root = Pathname.new(File.expand_path("../action", __FILE__))
      autoload :IsLinked, action_root.join("is_linked")
      autoload :IsReachable, action_root.join("is_reachable")
      autoload :MessageNotReachable, action_root.join("message_not_reachable")
      autoload :MessageNotLinked, action_root.join("message_not_linked")
      autoload :MessageAlreadyLinked, action_root.join("message_already_linked")
      autoload :ReadState, action_root.join("read_state")
      autoload :SyncFolders, action_root.join("sync_folders")
      autoload :WarnNetworks, action_root.join("warn_networks")
      autoload :LinkServer, action_root.join("link_server")
      autoload :UnlinkServer, action_root.join("unlink_server")
      autoload :RebootServer, action_root.join("reboot_server")
    end
  end
end
