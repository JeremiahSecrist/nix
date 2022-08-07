{ config, pkgs, lib, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware.nix
    # ./docker.nix
  ];
  environment.systemPackages = with pkgs; [ htop tailscale ];
  services.tailscale.enable = true;

  #### security settings
  boot.kernelPackages = pkgs.linuxPackages_hardened;
  boot.kernel.sysctl."kernel.unprivileged_userns_clone" = true;
  nix.settings.allowed-users = [ "@wheel" ];
  security.lockKernelModules = true;
  security.protectKernelImage = true;
  security.forcePageTableIsolation = true;
  ### 

  networking = {
    firewall.checkReversePath = "loose";
    hostName = "cache"; # Define your hostname.
    networkmanager.enable = true;
  };
  services.nix-serve = {
    enable = true;
    secretKeyFile = "/var/cache-priv-key.pem";
    port = 8080;
  };
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "owner@arouzing.xyz";
      dnsResolver = "1.1.1.1:53";
      dnsProvider = "cloudflare";
      credentialsFile = "/var/cf-token";
    };

  };
  services.nginx = {
    enable = true;
    virtualHosts = {
      "cache.local.arouzing.win" = {
        enableACME = true;
        onlySSL = true;
        # addSSL = true;
        serverAliases = [ "cache.local.arouzing.win" ];
        locations."/".extraConfig = ''
          proxy_pass http://localhost:${
            toString config.services.nix-serve.port
          };
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        '';
      };
    };
  };

  time.timeZone = "America/New_York";

  # Disable wait for network
  systemd.network.wait-online.timeout = 0;

  users.users.admin = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJAGm66rJsr8vjRCYDkH4lEPncPq27o6BHzpmRmkzOiM"
    ];
    description = "admin";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 80 443 ];
    allowedUDPPorts = [ ];
  };

  system.stateVersion = "22.05"; # Did you read the comment?

}
