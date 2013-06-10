require "log4r"

module VagrantPlugins
  module ManagedServers
    module Action
      # "Link" vagrant and the managed server
      class LinkServer
        
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_managed_servers::action::link_server")
        end

        def call(env)

          # Get the server hostname we're going to connect to
          server = env[:machine].provider_config.server

          # Prepare!
          env[:ui].info(I18n.t("vagrant_managed_servers.linking_server", :host => server))
          env[:ui].info(" -- Server: #{server}")
          
          # Immediately save the ID since it is created at this point.
          env[:machine].id = server

          @app.call(env)
        end
      end
    end
  end
end
