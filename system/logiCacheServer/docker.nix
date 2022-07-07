{ config, pkgs, lib, ... }:

{

    virtualisation.oci-containers = {
        backend = "docker";
        containers = {
            portainer = {
                image = "portainer/portainer-ce:2.14.0";
                ports = ["0.0.0.0:9443:9443"];
                volumes = [ "portainer_data:/data" "/var/run/docker.sock:/var/run/docker.sock" ];
            };
            lancache_monolith = {
                image = "lancachenet/monolithic:latest";
                # ports = ["0.0.0.0:80:80" "0.0.0.0:443:443"];
                volumes = [ 
                    "lancache_data:/data"
                    "lancache_data/cache:/data/cache"
                    "lancache_data/logs:/data/logs"
                    ];
                environment = {
                    USE_GENERIC_CACHE   =   "true";
                    LANCACHE_IP         =   "192.168.1.2";
                    DNS_BIND_IP         =   "192.168.1.2";
                    UPSTREAM_DNS        =   "1.1.1.1";
                    CACHE_DISK_SIZE     =   "600000m";
                    CACHE_MAX_AGE       =   "3650d";
                    TZ                  =   "America/Huston";
                };
                extraOptions = [
                    "--network=host"
                ];
            };
            lancache_dns = {
                image = "lancachenet/lancache-dns:latest";
                # ports = ["0.0.0.0:53:53"];
                environment = {
                    USE_GENERIC_CACHE   =   "true";
                    LANCACHE_IP         =   "192.168.1.2";
                    DNS_BIND_IP         =   "192.168.1.2";
                    UPSTREAM_DNS        =   "1.1.1.1";
                    CACHE_DISK_SIZE     =   "600000m";
                    CACHE_MAX_AGE       =   "3650d";
                    TZ                  =   "America/Huston";
                };
                extraOptions = [
                    "--network=host"
                ];
            };
        };
    };
}