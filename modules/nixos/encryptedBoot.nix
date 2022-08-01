_:
{ config, pkgs, lib, ... }:

{
  # Bootloader.
  boot.plymouth.enable = true;
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 1;
  };
  boot.initrd.luks.devices.luksroot = {
    #name = "root";
    device = "/dev/disk/by-label/luks";
    preLVM = true;
    allowDiscards = true;
  };
  fileSystems."/" = {
    options = [ "noatime" "nodiratime" "discard" ];
    device = "/dev/vg/nixos";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  swapDevices = [{ device = "/dev/vg/swap"; }];
}
