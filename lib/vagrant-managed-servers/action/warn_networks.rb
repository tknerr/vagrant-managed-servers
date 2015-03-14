module VagrantPlugins
  module ManagedServers
    module Action
      class WarnNetworks
        def initialize(app, env)
          @app = app
        end

        def call(env)
          if custom_networking_defined?(env)
            env[:ui].warn(I18n.t("vagrant_managed_servers.warn_networks"))
          end

          @app.call(env)
        end

        def custom_networking_defined?(env)
          network_configs = env[:machine].config.vm.networks
          custom_network_configs = (network_configs - default_network_configs)
          custom_network_configs.any?
        end

        #
        # these are the port forwardings which are always created by default, see:
        # https://github.com/mitchellh/vagrant/blob/a8dcf92f14/plugins/kernel_v2/config/vm.rb#L393-417
        #
        def default_network_configs
          ssh = [:forwarded_port, {
            guest: 22,
            host: 2222,
            host_ip: "127.0.0.1",
            id: "ssh",
            auto_correct: true,
            protocol: "tcp"
          }]
          return [ ssh ]
        end
      end
    end
  end
end
