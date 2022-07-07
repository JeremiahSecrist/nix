{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
      ./docker.nix
    ];
  
############# common
     # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # base packages
    environment.systemPackages = with pkgs; [
        gnumake
        nano
        git
        git-secret

    ];

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
        # prevent tampering
        readOnlyStore = true;

    };

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.utf8";

    # Performance
    # enable zram
    zramSwap.enable = true;



###################3


  networking = {
    hostName = "cacheserver"; # Define your hostname.
  #   defaultGateway = "192.168.1.254";
    nameservers = [ "1.1.1.1" ];
    enableIPv6 = false;
    interfaces.enp6s18.ipv4.addresses = [ {
      address = "192.168.1.2";
      prefixLength = 24;
    }   
  ];
    networkmanager.enable = true;
  };
  time.timeZone = "America/Huston";
  
  # Disable wait for network
  systemd.network.wait-online.timeout = 0;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.admin = {
    isNormalUser = true;
    initialPassword = "password";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPM5d9h1r7e4NBTUr5ZSO2dFTCZM3BNa5TKvgjqTJDOw"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKCYTCBJMl2N+6B+62+DYRK7DtgChb1vMeJ6jsVCOFTU"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9lk11IKYSwwbtv3ZPHZQTLrXrfmfbvbPbk2Q+Q+A9W"
    ];
    description = "admin";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };
  services.qemuGuest.enable = true;
  # Open ports in the firewall.
  networking.firewall = { 
    enable = false;
    # allowedTCPPorts = [];
    # allowedUDPPorts = [];
  };

 system.stateVersion = "22.05"; # Did you read the comment?

}