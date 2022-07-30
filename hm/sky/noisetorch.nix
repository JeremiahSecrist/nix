_: { config, pkgs, lib, ... }: 
{
systemd.user.services = {
  service-name = {
    Unit = {
      Description = "Example description";
      After="pulseaudio.service";
    };

    Service = {
        Type="simple";
        RemainAfterExit =   "yes";
        ExecStart       =   "${pkgs.noisetorch}/bin/noisetorch -i -s $DEVICEID -t 95";
        ExecStop        =   "${pkgs.noisetorch}/bin/noisetorch -u";
        Restart         =   "on-failure";
        RestartSec      =   3
    };
    Install = {
        WantedBy="default.target";
    };
  };
};
}