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
          communicator = env[:machine].config.vm.communicator
          network_configs = env[:machine].config.vm.networks
          custom_network_configs = (network_configs - default_network_configs(communicator))
          custom_network_configs.any?
        end

        #
        # these are the port forwardings which are always created by default, see:
        # https://github.com/mitchellh/vagrant/blob/a8dcf92f14/plugins/kernel_v2/config/vm.rb#L393-417
        #
        def default_network_configs(communicator)
          winrm = [:forwarded_port, {
            guest: 5985,
            host: 55985,
            host_ip: "127.0.0.1",
            id: "winrm",
            auto_correct: true,
            protocol: "tcp"
          }]
          winrm_ssl = [:forwarded_port, {
            guest: 5986,
            host: 55986,
            host_ip: "127.0.0.1",
            id: "winrm-ssl",
            auto_correct: true,
            protocol: "tcp"
          }]
          ssh = [:forwarded_port, {
            guest: 22,
            host: 2222,
            host_ip: "127.0.0.1",
            id: "ssh",
            auto_correct: true,
            protocol: "tcp"
          }]
          if communicator == :winrm
            [ winrm, winrm_ssl ]
          else
            [ ssh ]
          end
        end
      end
    end
  end
end
