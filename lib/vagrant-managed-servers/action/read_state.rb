require "log4r"

module VagrantPlugins
  module ManagedServers
    module Action
      # This action reads the state of the machine and puts it in the
      # `:machine_state_id` key in the environment.
      class ReadState
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_managed_servers::action::read_state")
        end

        def call(env)
          env[:machine_state_id] = read_state(env[:machine])
          @app.call(env)
        end

        def read_state(machine)
          return :not_linked if machine.id.nil?

          ip_address = machine.id
=begin
          if machine.communicate.ready?
            @logger.info "#{ip_address} is reachable and SSH login OK"
            return :reachable
          else
            if ssh_port_open? ip_address
              @logger.info "#{ip_address} is reachable, SSH port open (but login failed)"
              return :reachable
            else 
              if is_pingable? ip_address
                @logger.info "#{ip_address} is pingable (but SSH failed)"
                return :reachable
              end
            end
          end

          # host is not reachable at all...
          return :not_reachable
=end

          return machine.communicate.ready? ? :running : :not_reachable
        end


        def is_pingable?(ip)
          if Vagrant::Util::Platform.windows?
            system("ping -n 1 #{ip}")
          else
            system("ping -q -c 1 #{ip}")
          end
        end

        def ssh_port_open?(ip)
          is_port_open?(ip, 22)
        end

        #
        # borrowed from http://stackoverflow.com/a/3473208/2388971
        #
        def is_port_open?(ip, port)
          require 'socket'
          s = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM, 0)
          sa = Socket.sockaddr_in(port, ip)
          begin
            s.connect_nonblock(sa)
          rescue Errno::EINPROGRESS
            if IO.select(nil, [s], nil, 1)
              begin
                s.connect_nonblock(sa)
              rescue Errno::EISCONN
                return true
              rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
                return false
              end
            end
          end
          return false
        end
      end
    end
  end
end
