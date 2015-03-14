module VagrantPlugins
  module ManagedServers
    module Action
      class MessageAlreadyLinked
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info(I18n.t("vagrant_managed_servers.states.long_already_linked"))
          @app.call(env)
        end
      end
    end
  end
end
