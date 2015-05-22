module VagrantPlugins
  module ManagedServers
    module Action
      class WarnWinRMSyncedFolders
        def initialize(app, env)
          @app = app
        end

        def call(env)
          if env[:machine].config.vm.communicator == :winrm && !Vagrant.has_plugin?("vagrant-winrm-syncedfolders")
            env[:ui].warn(I18n.t("vagrant_managed_servers.warn_winrm_syncedfolders"))
          end

          @app.call(env)
        end
      end
    end
  end
end
