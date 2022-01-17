{ config, pkgs, ... }:

{
# init prereqs

    virtualisation.docker.enable = true;
    virtualisation.docker.enableOnBoot = true;
    virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      hass = {
        image = "portainer/portainer-ce:2.9.3";
        autostart = true;
        extraOptions = ["--restart=always"];
        ports = ["9443:9443"];
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
          "portainer_data:/data"
        ];
      };
    };


}