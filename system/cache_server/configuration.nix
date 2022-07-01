{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
    ];
  
  networking = {
    hostName = "cacheserver"; # Define your hostname.
    networkmanager.enable = true;
  };
  time.timeZone = "America/New_York";
  
  # Disable wait for network
  systemd.network.wait-online.timeout = 0;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.admin = {
    isNormalUser = true;
    initialPassword = "password";
    shell = pkgs.zsh;
    description = "sky";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };
    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall = { 
    enable = true;
    allowedTCPPorts = [ 22 ];
    allowedUDPPorts = [];
  };

 system.stateVersion = "22.05"; # Did you read the comment?

}