{ config, pkgs, lib, ... }:

{
  # Bootloader.
  boot.plymouth.enable = true;
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 1;
  };
  boot.luks.devices = {
	  crypted = {
	    device = "/dev/sda3";
	    preLVM = true;
      allowDiscards = true;
	  };
  };
  # boot.initrd.luks.devices.luksroot = {
  #   #name = "root";
  #   device = "/dev/sda";
  #   preLVM = true;
  #   allowDiscards = true;
  # };
}
