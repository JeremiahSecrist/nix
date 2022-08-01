{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod;

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ zenpower zfs xpadneo dpdk ];
  boot.kernelParams = [ "mitigations=off"];
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  
  #File systems
  
  # ssd optimization:
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];
  
  # mount games drive
  fileSystems."/home/sky/Games" =
  { device = "/dev/disk/by-label/games";
    fsType = "ext4";
  };
  
  # devices
  # bluetooth
  hardware.bluetooth.enable = true;

  # wooting keyboard
  hardware.wooting.enable = true;
  
  # networking
   # Disable wait for network
  systemd.network.wait-online.timeout = 0;
  
  time.timeZone = "America/New_York";
  
  networking.useDHCP = lib.mkDefault true;
  
  networking = {
    hostName = "desksky"; # Define your hostname.
    networkmanager.enable = true;
  };
}
