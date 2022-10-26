# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware.nix
    # ./fancontrol.nix
  ];
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sky = {
    uid = 1000;
    isNormalUser = true;
    initialPassword = "password";
    shell = pkgs.zsh;
    description = "sky";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" "kvm" ];
  };
  # fixes gnome login issues
  services.teamviewer.enable = true;
  programs.zsh.enable = true;
  programs.noisetorch.enable = true;
  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };
  services = { flatpak.enable = true; };
  services.fwupd.enable = true;
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-runtime"
    ];
  environment.systemPackages = with pkgs; [
    wooting-udev-rules
    wootility
    lutris
    tailscale

  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      false; # Open ports in the firewall for Source Dedicated Server
  };
  services.ipfs = { enable = true; };
  # Open ports in the firewall.
  hardware.wooting.enable = true;
  hardware.steam-hardware.enable = true;
  networking.firewall = {
    enable = false;
    allowedTCPPorts = [ 34197 27015 ];
    allowedUDPPorts = [ 34197 27015 ];
  };

  system.stateVersion = "22.05"; # Did you read the comment?

}
