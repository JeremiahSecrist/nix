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
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    boot.initrd.postDeviceCommands = lib.mkAfter ''
      if [ "$(stat -c %d:%i /)" != "$(stat -c %d:%i /proc/1/root/.)" ]; then
          echo "You are in a chroot environment."
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
        else
          echo "You are not in a chroot environment."
      fi
    '';

    fileSystems."/persist".neededForBoot = true;
    fileSystems."/persist/system".neededForBoot = true;
    environment.persistence."/persist/system" = {
      hideMounts = true;
      directories = [
        "/etc/nixos"
        "/var/log"
        "/home"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/etc/NetworkManager/system-connections"
        {
          directory = "/var/lib/colord";
          user = "colord";
          group = "colord";
          mode = "u=rwx,g=rx,o=";
        }
      ];
      files = [
        "/etc/machine-id"
        {
          file = "/var/keys/secret_file";
          parentDirectory = {mode = "u=rwx,g=,o=";};
        }
      ];
    };
  };
}
