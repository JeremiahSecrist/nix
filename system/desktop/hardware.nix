{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod;
  boot.extraModulePackages = with config.boot.kernelPackages; [
    zenpower
    zfs
    xpadneo
    dpdk
  ];
  boot.initrd.kernelModules = [ ];
  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.blacklistedKernelModules = [ "nvidia" "nouveau" ];
  boot.kernelModules =
    [ "kvm-amd" "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
  # boot.extraModprobeConfig = "options vfio-pci ids=10de:13c0,10de:0fbb";
  # boot.postBootCommands = ''
  #   DEVS="0000:0f:00.0 0000:0f:00.1"
  #   for DEV in $DEVS; do
  #     echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
  #   done
  #   modprobe -i vfio-pci
  # '';
  boot.kernelParams = [ "amd_iommu=on" "mitigations=off" ];

  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  #File systems

  # ssd optimization:
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  # mount games drive
  fileSystems."/home/sky/Games" = {
    device = "/dev/disk/by-label/games";
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
