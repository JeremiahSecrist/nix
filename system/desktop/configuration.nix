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
    hostName = "desksky"; # Define your hostname.
    networkmanager.enable = true;
  };
  time.timeZone = "America/New_York";
 
  # ssd optimization:
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  # mount games drive
  fileSystems."/home/sky/Games" =
    { device = "/dev/disk/by-label/games";
      fsType = "ext4";
    };
  # # mount home folder
  # fileSystems."/home" =
  #   { device = "/dev/disk/by-label/home";
  #     fsType = "ext4";
  #   };
  # bluetooth
  hardware.bluetooth.enable = true;
  
  # Disable wait for network
  systemd.network.wait-online.timeout = 0;

  programs.noisetorch.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sky = {
    isNormalUser = true;
    initialPassword = "password";
    shell = pkgs.zsh;
    description = "sky";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  services = {
    flatpak.enable = true; 
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
  ];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # Open ports in the firewall.
  networking.firewall = { 
    enable = true;
    allowedTCPPorts = [];
    allowedUDPPorts = [];
  };

 system.stateVersion = "22.05"; # Did you read the comment?

}
