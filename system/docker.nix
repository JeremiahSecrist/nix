{ config, pkgs, ... }:

{
    virtualisation.podman = {
        enable = true;
        dockerSocket.enable = true;
        dockerCompat = true;
    }
    virtualisation.oci-containers.backend = "podman";
    virtualisation.oci-containers.containers."portainer" = {
     image = "portainer/portainer-ce:2.11.0";
     ports = ["0.0.0.0:9443:9443"];
     volumes = [ "portainer_data:/data" "/var/run/docker.sock:/var/run/docker.sock" ];
    };
    systemd.services.dockerstop = {
      wantedBy = [ "containerd.service" ]; 
      before = [ "docker.service" ];
      after = [ "containerd.service" ];
      requires = ["containerd.service"];
      Description = "containerd-shim v2 workaround";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
        ExecStop = "/bin/sh -c ''${pkgs.docker}/bin/docker kill $(${pkgs.docker}/bin/docker ps -q)''";
      };
   };
}