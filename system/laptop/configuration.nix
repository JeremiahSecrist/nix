# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
      ./services.nix
    #   ./gnome.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  # boot.initrd.secrets = {
  #   "/crypto_keyfile.bin" = null;
  # };

  # Enable swap on luks
  # boot.initrd.luks.devices."luks-628e73c4-0740-4e30-8dce-7aa4c0dfc409".device = "/dev/disk/by-uuid/628e73c4-0740-4e30-8dce-7aa4c0dfc409";
  # boot.initrd.luks.devices."luks-628e73c4-0740-4e30-8dce-7aa4c0dfc409".keyFile = "/crypto_keyfile.bin";
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
      dates = "03:15";
    };
  };
  networking = {
    hostName = "skytop"; # Define your hostname.
    networkmanager.enable = true;
  };
  # NM DNS
  
  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Enable the GNOME Desktop Environment.
  programs.xwayland.enable = true;
  
  # bluetooth
  hardware.bluetooth.enable = true;
  
  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sky = {
    isNormalUser = true;
    initialPassword = "password";
    description = "sky";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    remake
    protonvpn-gui
    ecryptfs
    ecryptfs-helper
    nano
    git
    firefox-wayland
    gnome3.gnome-tweaks
    spotify
    cryptomator
    distrobox
    vscode-fhs
    ];

  xdg.portal = {
   enable = true;
   extraPortals = [ pkgs.xdg-desktop-portal-kde ];
  };
  zramSwap.enable = true;
  virtualisation = {
    podman = {
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
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

 system.stateVersion = "22.05"; # Did you read the comment?

}
