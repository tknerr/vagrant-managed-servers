require "log4r"
require "timeout"

module VagrantPlugins
  module ManagedServers
    module Action
      # reboot the managed server
      class RebootServer

        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_managed_servers::action::reboot_server")
        end

        def call(env)
          server = env[:machine].id

          boot_timeout = env[:machine].config.vm.boot_timeout ## This is user configurable, defaults to 300 seconds

          # "Reboot"
          env[:ui].info(I18n.t("vagrant_managed_servers.rebooting_server", :host => server))
          env[:ui].info(" -- Server: #{server}")
          send_reboot(env[:machine])
          # We don't want to spin endlessly waiting for the machine to come back.
          # Wait for the config.vm.boot_timeout amount of time.
          begin
            Timeout::timeout(boot_timeout) {
              # keep track of if the server has gone unreachable
              machine_up = true
              while machine_up
                begin
                  # communicate.ready? takes a long time to return false (the indication that the machine has gone down for reboot)
                  # and this was causing the loop to never register that the machine had gone down. So if it has taken a long time to
                  # return, we assume that the machine has indeed gone down.
                  status = Timeout::timeout(5) { machine_up = env[:machine].communicate.ready? }
                rescue Exception => err
                  # The Timeout::Error is getting swallowed somewhere. If err is execution expired, then the timeout was hit.
                  # Otherwise re-raise err
                  raise err unless err.message == "execution expired"
                  # Machine is down. Wait for it to come back up!
                  env[:ui].info(I18n.t("vagrant_managed_servers.waiting_for_server", :host => server))
                  until env[:machine].communicate.ready?
                    sleep 1
                  end
                  machine_up = false
                end
                sleep 1
                env[:ui].info(I18n.t("vagrant_managed_servers.waiting_for_server", :host => server))
              end
              env[:ui].info(" #{server} rebooted and ready.")
              @app.call(env)
            }
          rescue Exception => err
            raise err unless err.message == "execution expired"
            env[:ui].error("Timed out waiting for machine to reboot!")
          end
        end

        def send_reboot(machine)
          if (machine.config.vm.communicator == :winrm)
            machine.communicate.sudo("shutdown -f -r -t 0")
          else
            machine.communicate.sudo("reboot")
          end

        end

      end
    end
  end
end
