module VagrantPlugins
  module ManagedServers
    module Action
      class MessageNotLinked
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:ui].info(I18n.t("vagrant_managed_servers.states.long_not_linked"))
          @app.call(env)
        end
      end
    end
  end
end
