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
    device = "/dev/sda";
    preLVM = true;
    allowDiscards = true;
  };
}
