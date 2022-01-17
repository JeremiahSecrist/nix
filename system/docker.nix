{ config, pkgs, ... }:

{
# init prereqs
    # virtualisation.docker.enable = true;
    virtualisation.podman= {
        enable = true;
        dockerSocket.enable = true;
    }
    virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      hass = {
        image = "cr.portainer.io/portainer/portainer-ce:2.9.3";
        autostart = true;
        extraOptions = ["--restart=always"];
        user = "admin";
        workdir = "/home/admin";
        ports = ["9443:9443"];
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
          "portainer_data:/data"
        ];
      };
    };


}