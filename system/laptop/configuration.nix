# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
#      ./harden.nix
      ./hardware.nix
      ./services.nix
      ./gnome.nix
    ];

  # Bootloader.
  boot.plymouth.enable = true;
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
 

  nix = {
    # nix flakes
    package = pkgs.nixUnstable; # or versioned attributes like nix_2_4
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    #auto maintainence
    autoOptimiseStore = true;
    gc ={
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
  
  networking = {
    hostName = "skytop"; # Define your hostname.
    networkmanager.enable = true;
  };
  time.timeZone = "America/New_York";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";
  # Enable the GNOME Desktop Environment.
  programs = {
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
  security = {
    pam = {
      u2f = {
        enable = true;
        control = "sufficient";
        cue = true;
      };
      services = {
        login.u2fAuth = true;
        gdm.u2fAuth = true;
        slock.u2fAuth = true;
      };
    };
  };
  # nixpkgs.config.packageOverrides = pkgs: with pkgs; {
  #   firefox = stdenv.lib.overrideDerivation firefox (_: {
  #     desktopItem = makeDesktopItem {...};
  #   });
  # };
  # bluetooth
  hardware.bluetooth.enable = true;
  
  # Disable wait for network
  systemd.network.wait-online.timeout = 0;
  boot.loader.timeout = 1;
  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sky = {
    isNormalUser = true;
    initialPassword = "password";
    description = "sky";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    gnumake
    nano
    git
    python39Packages.dbus-python
    ecryptfs
    ecryptfs-helper
    ];
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gnome-keyring.u2fAuth = true;
  zramSwap.enable = true;
  virtualisation = {
    docker.liveRestore = false;
    docker = {
      # dockerCompat = true;
      # dockerSocket.enable = true;
      
      enable = true;
    };
  };
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs = { 
   starship.enable = true;
  };
  security.pam.enableEcryptfs = true;
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall = { 
    enable = true;
    allowedTCPPorts = [];
    allowedUDPPorts = [];
  };

 system.stateVersion = "22.05"; # Did you read the comment?

}
