# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
    ];
  
  networking = {
    hostName = "skytop"; # Define your hostname.
    networkmanager.enable = true;
  };
  time.timeZone = "America/New_York";
 
  
  # bluetooth
  hardware.bluetooth.enable = true;
  
  # Disable wait for network
  systemd.network.wait-online.timeout = 0;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sky = {
    isNormalUser = true;
    initialPassword = "password";
    description = "sky";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };
  services = {
    flatpak.enable = true; 
    xserver.libinput.enable = true;
  };

  # Open ports in the firewall.
  networking.firewall = { 
    enable = true;
    allowedTCPPorts = [];
    allowedUDPPorts = [];
  };

 system.stateVersion = "22.05"; # Did you read the comment?

}
