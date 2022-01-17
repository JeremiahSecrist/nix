{ config, pkgs, ... }:

{
    virtualisation.docker.enable = true;
    virtualisation.oci-containers.backend = "docker";
    virtualisation.oci-containers.containers."portainer" = {
     image = "portainer/portainer-ce:2.11.0";
     ports = ["0.0.0.0:9443:9443"];
     volumes = [ "portainer_data:/data" "/var/run/docker.sock:/var/run/docker.sock" ];
    };

}