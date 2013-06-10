module VagrantPlugins
  module ManagedServers
    module Action
      class MessageNotReachable
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info(I18n.t("vagrant_managed_servers.host_not_reachable"))
          @app.call(env)
        end
      end
    end
  end
end
