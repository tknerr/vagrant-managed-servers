require "log4r"

require "vagrant/util/subprocess"

require "vagrant/util/scoped_hash_override"

require "vagrant/util/which"

module VagrantPlugins
  module ManagedServers
    module Action
      # This middleware uses `rsync` to sync the folders over to the
      # AWS instance.
      class SyncFolders
        include Vagrant::Util::ScopedHashOverride
        include Vagrant::Util::Retryable

        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_managed_servers::action::sync_folders")
        end

        def call(env)
          @app.call(env)

          ssh_info = env[:machine].ssh_info

          env[:machine].config.vm.synced_folders.each do |id, data|
            data = scoped_hash_override(data, :aws)

            # Ignore disabled shared folders
            next if data[:disabled]

            hostpath  = File.expand_path(data[:hostpath], env[:root_path])
            guestpath = data[:guestpath]

            unless Vagrant::Util::Which.which('rsync')
              env[:ui].warn(I18n.t('vagrant_managed_servers.rsync_not_found_warning'))
              break
            end

            # Make sure there is a trailing slash on the host path to
            # avoid creating an additional directory with rsync
            hostpath = "#{hostpath}/" if hostpath !~ /\/$/

            # on windows rsync.exe requires cygdrive-style paths
            if Vagrant::Util::Platform.windows?
              hostpath = hostpath.gsub(/^(\w):/) { "/cygdrive/#{$1}" }
            end

            env[:ui].info(I18n.t("vagrant_managed_servers.rsync_folder",
                                :hostpath => hostpath,
                                :guestpath => guestpath))

            # Create the guest path
            env[:machine].communicate.sudo("mkdir -p '#{guestpath}'")
            env[:machine].communicate.sudo(
              "chown -R '#{ssh_info[:username]}' '#{guestpath}'")

            # Rsync over to the guest path using the SSH info
            ssh_key_options = Array(ssh_info[:private_key_path]).map { |path| "-i '#{path}' " }.join
            ssh_proxy_commands = Array(ssh_info[:proxy_command]).map { |command| "-o ProxyCommand='#{command}' "}.join
            command = [
              "rsync", "--verbose", "--archive", "-z",
              "--exclude", ".vagrant/", "--exclude", "Vagrantfile",
              "-e", "ssh -l '#{ssh_info[:username]}' -p #{ssh_info[:port]} -o StrictHostKeyChecking=no #{ssh_key_options} #{ssh_proxy_commands}",
              hostpath,
              "#{ssh_info[:host]}:#{guestpath}"]

            # we need to fix permissions when using rsync.exe on windows, see
            # http://stackoverflow.com/questions/5798807/rsync-permission-denied-created-directories-have-no-permissions
            if Vagrant::Util::Platform.windows?
              command.insert(1, "--chmod", "ugo=rwX")
            end

            r = Vagrant::Util::Subprocess.execute(*command)
            if r.exit_code != 0
              raise Errors::RsyncError,
                :guestpath => guestpath,
                :hostpath => hostpath,
                :stderr => r.stderr
            end
          end
        end
      end
    end
  end
end
