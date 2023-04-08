# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, ... }:

{
  networking = {
    hostName = "lappy"; # Define your hostname.
  };
  programs.noisetorch.enable = true;
  services = {
    fwupd.enable = true;
  };
  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
  };
  nix.registry.self.flake = inputs.self;
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  system.stateVersion = "22.11";

}
