{ config, pkgs, lib, ... }:

{
  # networking.firewall.allowedTCPPorts = [ 53 80 443 9443 ];

  # virtualisation.oci-containers = {
  #   backend = "docker";
  #   containers = {
  #     portainer = {
  #       image = "portainer/portainer-ce:2.14.0";
  #       ports = [ "0.0.0.0:9443:9443" ];
  #       volumes = [
  #         "portainer_data:/data"
  #         "portainer_data:/data"
  #         "/var/run/docker.sock:/var/run/docker.sock"
  #       ];
  #       extraOptions = [ "--label=docker.group=all" ];
  #     };
  #     lancache_monolith = {
  #       image = "lancachenet/monolithic:latest";
  #       ports = [ "0.0.0.0:80:80" "0.0.0.0:443:443" ];
  #       volumes = [
  #         "/var/lib/lancache_data/cache:/data/cache"
  #         "/var/lib/lancache_data/logs:/data/logs"
  #       ];
  #       environment = {
  #         USE_GENERIC_CACHE = "true";
  #         LANCACHE_IP = "10.0.1.92";
  #         DNS_BIND_IP = "10.0.1.92";
  #         UPSTREAM_DNS = "8.8.8.8";
  #         CACHE_DISK_SIZE = "100000m";
  #         CACHE_MAX_AGE = "3650d";
  #         TZ = "America/New_York";
  #       };
  #       extraOptions = [ "--label=docker.group=all" ];
  #     };
  #     lancache_dns = {
  #       image = "lancachenet/lancache-dns:latest";
  #       ports = [ "0.0.0.0:53:53" ];
  #       environment = {
  #         USE_GENERIC_CACHE = "true";
  #         LANCACHE_IP = "10.0.1.92";
  #         DNS_BIND_IP = "10.0.1.92";
  #         UPSTREAM_DNS = "8.8.8.8";
  #         CACHE_DISK_SIZE = "100000m";
  #         CACHE_MAX_AGE = "3650d";
  #         TZ = "America/New_York";
  #       };
  #       extraOptions = [ "--label=docker.group=all" ];
  #     };
  #     # pihole = {
  #     #     image = "pihole/pihole:latest";
  #     #     volumes = [ 
  #     #         "pihole_data/etc-pihole:/etc/pihole"
  #     #         "pihole_data/etc-dnsmasq.d:/etc/dnsmasq.d"
  #     #         ];
  #     #     ports = ["0.0.0.0:8080:80"];
  #     #     environment = {
  #     #         TZ                  =   "America/New_York";
  #     #     };
  #     # };
  #   };
  # };
}
