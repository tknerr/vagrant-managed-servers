require "vagrant"

module VagrantPlugins
  module SyncedFolderWinRM
    # This plugin implements WinRM synced folders.
    class Plugin < Vagrant.plugin("2")
      name "WinRM synced folders"
      description <<-EOF
      The WinRM synced folders plugin enables you to use WinRM as a mechanism
      to transfer files to a guest machine. There are known limitations to this
      mechanism, most notably that file tranfer is slow for large numbers of files.
      EOF

      synced_folder("winrm", 6) do
        require_relative "synced_folder"
        init!
        SyncedFolder
      end

      def self.init!
      end
    end
  end
end
