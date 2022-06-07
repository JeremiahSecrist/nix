# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/master)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./desktop.nix
      # ./homemanager.nix
    ];
  boot.loader = {
    #grub.device = "/dev/sda";
    systemd-boot.enable = true;
    timeout = 1;
  };

  nixpkgs.config.allowUnfree = true;
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


  # Set your time zone.
  time.timeZone = "America/New_York";
  networking= {
    hostName = "skytop";
    useDHCP = false;
    interfaces.enp0s25.useDHCP = true;
    interfaces.wlp4s0.useDHCP = true;
    firewall = {
      allowedTCPPorts = [  ];
      allowedUDPPorts = [ ];
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sky = {
    isNormalUser = true;
    initialPassword = "changeme!!";
    # openssh.authorizedKeys.keys = [
    #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPM5d9h1r7e4NBTUr5ZSO2dFTCZM3BNa5TKvgjqTJDOw"
    #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKCYTCBJMl2N+6B+62+DYRK7DtgChb1vMeJ6jsVCOFTU"
    # ];
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  
  environment.systemPackages = with pkgs; [
    microcodeIntel
    lm_sensors
    nano 
    wget
    git 
    #desktop
    firefox
    unstable.noisetorch
  ];

  # Enable flatpak
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh ={
  #   enable = true;
  #   passwordAuthentication = false;
  # };
  # Open ports in the firewall.

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

