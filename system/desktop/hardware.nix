{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod;
  boot.extraModulePackages = with config.boot.kernelPackages; [ zenpower ];
  boot.initrd.kernelModules = [ ];
  boot.initrd.availableKernelModules =
    [ "amdgpu" "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  # boot.blacklistedKernelModules = [ "nvidia" "nouveau" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelParams = [ "mitigations=off" ];

  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  # gpu settings

  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
    amdvlk
  ];

  hardware.opengl.extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];

  hardware.opengl = {
    driSupport = lib.mkDefault true;
    driSupport32Bit = lib.mkDefault true;
  };

  environment.variables.AMD_VULKAN_ICD = lib.mkDefault "RADV";

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

  # bluetooth fix for soft restarts
  systemd.services.from-sleep = {
    description = "Fixes for generic USB bluetooth dongle.";
    wantedBy = [ "post-resume.target" ];
    after = [ "post-resume.target" ];
    script = builtins.readFile ./usbreset.sh;
    scriptArgs = "8087:0029 enp5s0"; # Vendor ID and Product ID here
    serviceConfig.Type = "oneshot";
  };

  # wooting keyboard
  # hardware.wooting.enable = true;

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
