{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
      ./docker.nix
    ];
  
  networking = {
    hostName = "cacheserver"; # Define your hostname.
    defaultGateway = "192.168.1.254";
    interfaces.eth0.ipv4.addresses = [ {
      address = "192.168.1.2";
      prefixLength = 24;
    }   
  ];
    networkmanager.enable = true;
  };
  time.timeZone = "America/Denver";
  
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
    enable = true;
    allowedTCPPorts = [8086 3000];
    allowedUDPPorts = [];
  };

 system.stateVersion = "22.05"; # Did you read the comment?

}