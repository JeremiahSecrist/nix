{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.impermanence;
in {
  options.local.impermanence.enable = lib.mkEnableOption "enables vm settings";
  config = lib.mkIf cfg.enable {
    environment.etc."machine-id" = {
      text = "87f2201d1aa14509b92aba0d5e67be96";
      mode = "0644";
    };
    
    boot.initrd.postDeviceCommands = lib.mkAfter ''
      mkdir /btrfs_tmp
      mount /dev/root_vg/root /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi
      delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
          delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
      }
      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
      done
      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';

    fileSystems."/persist".neededForBoot = true;
    # fileSystems."/Games".neededForBoot = true;
    environment.persistence."/persist/system" = {
      hideMounts = true;
      directories = [
        "/root"
        "/etc/nixos"
        "/var/log"
        # "/home"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/lib/misc"
        "/etc/NetworkManager/system-connections"
        # "/var/lib/NetworkManager"
        # "/etc/NetworkManager"
        # "/var/lib/NetworkManager-fortisslvpn"
        # "/etc/ipsec.d"
        # "/run/pppd/lock"
        # {
        #   directory = "/var/lib/NetworkManager";
        #   user = "networkmanager";
        #   group = "networkmanager";
        #   mode = "u=rwx,g=rx,o=";
        # }
        {
          directory = "/var/lib/colord";
          user = "colord";
          group = "colord";
          mode = "u=rwx,g=rx,o=";
        }
      ];
      files = [
        {
          file = "/var/keys/secret_file";
          parentDirectory = {mode = "u=rwx,g=,o=";};
        }
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
      ];
    };
  };
}
