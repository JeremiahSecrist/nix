{ config, pkgs, ... }:

{
    virtualisation.docker= {
        liveRestore = false;
    };
    users.groups.docker.members = config.users.groups.wheel.members;
    virtualisation.oci-containers= {
        backend = "docker";
        containers."portainer" = {
        image = "portainer/portainer-ce:2.11.0";
        ports = ["0.0.0.0:9443:9443"];
        volumes = [ "portainer_data:/data" "/var/run/docker.sock:/var/run/docker.sock" ];
        };
    };
    systemd = {
        timers.docker-prune = {
            wantedBy = [ "timers.target" ];
            partOf = [ "docker-prune.service" ];
            timerConfig.OnCalendar = "weekly";
        };
    services.docker-prune = {
        serviceConfig.Type = "oneshot";
        script = ''
          ${pkgs.docker}/bin/docker system prune --all --force
        '';
        requires = [ "docker.service" ];
    };
  };
}