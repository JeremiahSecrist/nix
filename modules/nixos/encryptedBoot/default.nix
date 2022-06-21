_: { config, pkgs, lib, ... }:

{    
    # Bootloader.
    boot.plymouth.enable = true;
    boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        timeout = 1;
    };
    boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/disk/by-label/LUKS";
      preLVM = true;
      allowDiscards = true;
    }
    ];
    fileSystems."/" ={ 
          device = "/dev/disk/by-label/nixos";
          fsType = "ext4";
      };
    fileSystems."/boot" = { 
          device = "/dev/disk/by-label/boot";
          fsType = "vfat";
      };
    
    swapDevices = [ 
      { device = "/dev/disk/by-label/swap"; }
      ];
}