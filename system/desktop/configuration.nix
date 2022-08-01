# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware.nix
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sky = {
    isNormalUser = true;
    initialPassword = "password";
    shell = pkgs.zsh;
    description = "sky";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "kvm" ];
  };

  # fixes gnome login issues
  programs.zsh.enable = true;
  programs.noisetorch.enable = true;

  services = { flatpak.enable = true; };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-runtime"
    ];
  environment.systemPackages = with pkgs; [ tailscale ];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
  };

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };

  system.stateVersion = "22.05"; # Did you read the comment?

}
