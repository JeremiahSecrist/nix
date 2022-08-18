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
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    networkmanager.enable = true;
  };
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "owner@arouzing.xyz";
      # server = "https://acme-staging-v02.api.letsencrypt.org/directory";
      dnsResolver = "1.1.1.1:53";
      dnsProvider = "cloudflare";
      credentialsFile = "/var/cf-token";
    };
    certs = { "cache.local.arouzing.win" = { dnsResolver = "1.1.1.1:53"; }; };
  };
  users.users.nginx.extraGroups = [ "acme" ];
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
    appendConfig = ''
      worker_processes auto;
      worker_cpu_affinity auto;
    '';
    appendHttpConfig = ''
      proxy_cache_path /var/cache/nginx/  levels=1:2 keys_zone=cachecache:100m max_size=200g inactive=365d use_temp_path=off;
      access_log /var/log/nginx/access.log;
    '';
    virtualHosts = {
      "cache.local.arouzing.win" = {
        useACMEHost = "cache.local.arouzing.win";
        onlySSL = true;
        locations."/" = {
          proxyPass = "https://cache.nixos.org";
          extraConfig = ''
            aio threads;
            resolver 1.1.1.1;
            proxy_cache cachecache;
          '';
        };
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
    allowedTCPPorts = [ 22 80 443 5000 ];
    allowedUDPPorts = [ 5000 ];
  };

  system.stateVersion = "22.05"; # Did you read the comment?

}
