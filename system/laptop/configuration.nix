# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/02ab2e2aa58df6231c319af3ce1af79f3e82e2d8)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./gnome.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Setup keyfile
  # boot.initrd.secrets = {
    # "/crypto_keyfile.bin" = null;
  # };

  # # Enable swap on luks
  # boot.initrd.luks.devices."luks-628e73c4-0740-4e30-8dce-7aa4c0dfc409".device = "/dev/disk/by-uuid/628e73c4-0740-4e30-8dce-7aa4c0dfc409";
  # boot.initrd.luks.devices."luks-628e73c4-0740-4e30-8dce-7aa4c0dfc409".keyFile = "/crypto_keyfile.bin";

  networking = {
    hostName = "skytop"; # Define your hostname.
    networkmanager.enable = true;
  };
  # NM DNS
  
  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";
  
  # bluetooth
  hardware.bluetooth.enable = true;
  
  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sky = {
    isNormalUser = true;
    description = "sky";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Packages to install
  environment.systemPackages = with pkgs; [
    nano
    git
    firefox-wayland
    gnome3.gnome-tweaks
    unstable.noisetorch
    spotify
    cryptomator
    distrobox
    vscode
    ];

  xdg.portal = {
    enable = true;
#   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  virtualisation = {
    podman = {
      enable = true;
    };
  };
  programs = { 
   starship.enable = true;
  };
   # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
