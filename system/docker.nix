{ config, pkgs, ... }:

{
    virtualisation.docker.enable = true;
    virtualisation.oci-containers.backend = "docker";
    virtualisation.oci-containers.containers."portainer" = {
     image = "portainer/portainer-ce:2.11.0";
     ports = ["0.0.0.0:9443:9443"];
     volumes = [ "portainer_data:/data" "/var/run/docker.sock:/var/run/docker.sock" ];
    };
    systemd.services.dockerstop = {
      wantedBy = [ "containerd.service" ]; 
      before = [ "docker.service" ];
      requires = ["containerd.service"];
      description = "containerd-shim v2 workaround";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
        ExecStop = "${pkg.docker}/bin/docker kill $(${pkg.docker}/bin/docker ps -q)";
      };
   };
}