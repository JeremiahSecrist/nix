{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
      ./docker.nix
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
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPM5d9h1r7e4NBTUr5ZSO2dFTCZM3BNa5TKvgjqTJDOw"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKCYTCBJMl2N+6B+62+DYRK7DtgChb1vMeJ6jsVCOFTU"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC9lk11IKYSwwbtv3ZPHZQTLrXrfmfbvbPbk2Q+Q+A9W"
    ];
    description = "admin";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };
    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

  # enable influxdb
  services.influxdb2.enable = true;

  # enable telegraf to log myself!
  services.telegraf = {
    enable = true;
    extraConfig = {
      inputs = {
        statsd = {
          delete_timings = true;
          service_address = ":8125";
        };
      };
      outputs = {
        influxdb = {
          database = "telegraf";
          urls = [
            "http://localhost:8086/api/v2/telegrafs/099d51d0a3960000"
          ];
        };
      };
    };
    enviormentFiles = [
      "./telegraf.env"
    ];
  };

  # Open ports in the firewall.
  networking.firewall = { 
    enable = true;
    allowedTCPPorts = [8086];
    allowedUDPPorts = [];
  };

 system.stateVersion = "22.05"; # Did you read the comment?

}