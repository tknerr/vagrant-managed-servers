module VagrantPlugins
  module ManagedServers
    module Action
      # This can be used with "Call" built-in to check if the machine
      # is linked and branch in the middleware.
      class IsLinked
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:result] = env[:machine].state.id != :not_linked
          @app.call(env)
        end
      end
    end
  end
end
