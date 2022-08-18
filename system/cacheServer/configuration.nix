{ config, pkgs, lib, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware.nix
    # ./docker.nix
  ];
  environment.systemPackages = with pkgs; [ htop tailscale ];
  services.tailscale.enable = true;
  networking = {
    firewall.checkReversePath = "loose";
    hostName = "cache"; # Define your hostname.
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    networkmanager.enable = true;
  };
  boot.kernelModules = [ "tcp_bbr" ];

  # Enable BBR congestion control
  boot.kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr";
  boot.kernel.sysctl."net.core.default_qdisc" =
    "fq"; # see https://news.ycombinator.com/item?id=14814530

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

  fileSystems."/var/cache/nginx-temp" = {
    device = "none";
    fsType = "tmpfs";
    options = [
      "uid=${toString config.users.users.nginx.uid}"
      "gid=${toString config.users.groups.nginx.gid}"
      "rw"
      "size=4G"
      "mode=700"
    ];
  };
  users.users.nginx.uid = 60;
  users.groups.nginx.gid = 60;
  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    appendHttpConfig = ''
      proxy_cache_path /var/cache/nginx/ 
      levels=1:2 
      keys_zone=cachecache:100m 
      max_size=20g 
      inactive=365d
      use_temp_path=on;
      proxy_temp_path /var/cache/nginx-temp
      1 2
      ;
      # Cache only success status codes; in particular we don't want to cache 404s.
      # See https://serverfault.com/a/690258/128321
      map $status $cache_header {
        200     "public";
        302     "public";
        default "no-cache";
      }
      access_log /var/log/nginx/access.log;
    '';
    virtualHosts = {
      "cache.local.arouzing.win" = {
        useACMEHost = "cache.local.arouzing.win";
        onlySSL = true;
        locations."/" = {
          root = "/var/public-nix-cache";
          extraConfig = ''
            expires max;
            add_header Cache-Control $cache_header always;
            # Ask the upstream server if a file isn't available locally
            error_page 404 = @fallback;
          '';
        };

        extraConfig = ''
          # Using a variable for the upstream endpoint to ensure that it is
          # resolved at runtime as opposed to once when the config file is loaded
          # and then cached forever (we don't want that):
          # see https://tenzer.dk/nginx-with-dynamic-upstreams/
          # This fixes errors like
          #   nginx: [emerg] host not found in upstream "upstream.example.com"
          # when the upstream host is not reachable for a short time when
          # nginx is started.
          resolver 1.1.1.1;
          set $upstream_endpoint https://cache.nixos.org;
        '';

        locations."@fallback" = {
          proxyPass = "$upstream_endpoint";
          extraConfig = ''
            proxy_http_version 1.1;
            proxy_set_header Connection "";
            proxy_ssl_server_name on;

            proxy_set_header Host $proxy_host;
            proxy_cache cachecache;
            proxy_cache_valid  200 302  360d;
            expires max;
            add_header Cache-Control $cache_header always;
          '';
        };

        # We always want to copy cache.nixos.org's nix-cache-info file,
        # and ignore our own, because `nix-push` by default generates one
        # without `Priority` field, and thus that file by default has priority
        # 50 (compared to cache.nixos.org's `Priority: 40`), which will make
        # download clients prefer `cache.nixos.org` over our binary cache.
        locations."= /nix-cache-info" = {
          # Note: This is duplicated with the `@fallback` above,
          # would be nicer if we could redirect to the @fallback instead.
          proxyPass = "$upstream_endpoint";
          extraConfig = ''
            proxy_http_version 1.1;
            proxy_set_header Connection "";
            proxy_ssl_server_name on;

            proxy_set_header Host $proxy_host;
            proxy_cache cachecache;
            proxy_cache_valid  200 302  360d;
            expires max;
            add_header Cache-Control $cache_header always;
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
