# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./var.nix
    ];
  boot.loader.systemd-boot.enable = true;
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  
  nix = {
    package = pkgs.nixUnstable; # or versioned attributes like nix_2_4
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  networking.hostName = "nixcontainer"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/New_York";
  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.admin = {
    isNormalUser = true;
    initialPassword = "changeme!!";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPM5d9h1r7e4NBTUr5ZSO2dFTCZM3BNa5TKvgjqTJDOw"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKCYTCBJMl2N+6B+62+DYRK7DtgChb1vMeJ6jsVCOFTU"
    ]
    extraGroups = [ "wheel" "docker" "podman" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nano # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget 
    # firefox 
    git 
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 9443 ];
  networking.firewall.allowedUDPPorts = [  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

