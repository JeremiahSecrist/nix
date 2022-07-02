{ config, pkgs, lib, ... }:

{
    networking.firewall.allowedTCPPorts = [ 9443 ];
    virtualisation.oci-containers = {
        backend = "docker";
        containers = {
            portainer = {
                image = "portainer/portainer-ce:2.11.0";
                ports = ["0.0.0.0:9443:9443"];
                volumes = [ "portainer_data:/data" "/var/run/docker.sock:/var/run/docker.sock" ];
            };
            lancache_monolith = {
                image = "lancachenet/monolithic:latest";
                ports = ["0.0.0.0:80:80" "0.0.0.0:443:443"];
                volumes = [ "lancache_data/data:/data" "lancache_data/logs:/logs" ];
                environment = {
                    USE_GENERIC_CACHE   =   "true";
                    LANCACHE_IP         =   "10.0.1.92";
                    DNS_BIND_IP         =   "10.0.1.92";
                    UPSTREAM_DNS        =   "8.8.8.8";
                    CACHE_ROOT          =   "/lancache";
                    CACHE_DISK_SIZE     =   "100000m";
                    CACHE_MAX_AGE       =   "3650d";
                    TZ                  =   "America/New_York";
                };
            };
            lancache_dns = {
                image = "lancachenet/lancache-dns:latest";
                ports = ["0.0.0.0:53:53"];
                environment = {
                    USE_GENERIC_CACHE   =   "true";
                    LANCACHE_IP         =   "10.0.1.92";
                    DNS_BIND_IP         =   "10.0.1.92";
                    UPSTREAM_DNS        =   "8.8.8.8";
                    CACHE_ROOT          =   "/lancache";
                    CACHE_DISK_SIZE     =   "100000m";
                    CACHE_MAX_AGE       =   "3650d";
                    TZ                  =   "America/New_York";
                };
            };
        };
    };
}