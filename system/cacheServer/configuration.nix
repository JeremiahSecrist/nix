{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
      ./docker.nix
    ];
  #### temp for testing
  boot.kernelPackages = mkDefault pkgs.linuxPackages_hardened;
  boot.kernel.sysctl."kernel.unprivileged_userns_clone" = mkDefault true;
  nix.settings.allowed-users = mkDefault [ "@users" ];
  security.lockKernelModules = mkDefault true;
  security.protectKernelImage = mkDefault true;
  security.allowSimultaneousMultithreading = mkDefault false;
  security.forcePageTableIsolation = mkDefault true;
  # This is required by podman to run containers in rootless mode.
  security.unprivilegedUsernsClone = mkDefault config.virtualisation.containers.enable;
  security.virtualisation.flushL1DataCache = mkDefault "always";

  ###
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
    # initialPassword = "password";
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

  # enable grafana
  services.grafana = {
    enable = true;
    # port     = 3000;
    addr = "0.0.0.0";
    protocol = "http";
    dataDir  = "/var/lib/grafana";
  };
  # enable telegraf to log myself!
  services.telegraf = {
    enable = true;
    extraConfig = {
      inputs = {
        docker = {
          endpoint = "unix:///var/run/docker.sock";
          gather_services = false;
          container_name_include = [];
          container_name_exclude = [];
          timeout = "5s";
          docker_label_include = [];
          docker_label_exclude = [];
          perdevice = true;
          total = false;
        };
        internet_speed = {
          enable_file_download = true;
        };
        disk = {
          ignore_fs = ["tmpfs" "devtmpfs" "devfs" "iso9660" "overlay" "aufs" "squashfs"];
        };
        diskio = { };
        mem = {};
        cpu = {
          ## Whether to report per-cpu stats or not
          percpu = true;
          ## Whether to report total system cpu stats or not
          totalcpu = true;
          ## If true, collect raw CPU time metrics
          collect_cpu_time = false;
          ## If true, compute and report the sum of all non-idle CPU states
          report_active = false;
        };

        # minecraft = {
        #   server = "";
        #   port = "25575";
        #   password = "$MINECRAFT_PASSWORD"
        # }
      };
      outputs = {
        influxdb_v2 = {
          urls = ["http://127.0.0.1:8086"];

          ## Token for authentication.
          token = "$INFLUX_TOKEN";

          ## Organization is the name of the organization you wish to write to; must exist.
          organization = "arouzing";

          ## Destination bucket to write into.
          bucket = "arouzingBucket";
        };
      };
    };
  ####

    environmentFiles = [
      "/etc/telegraf.env"
    ];
  };
    # must add telegraf to docker group
    users.users.telegraf = {
      extraGroups = [ "docker" ];
    };

  # Open ports in the firewall.
  networking.firewall = { 
    enable = true;
    allowedTCPPorts = [8086 3000];
    allowedUDPPorts = [];
  };

 system.stateVersion = "22.05"; # Did you read the comment?

}