{ config, pkgs, lib, ... }: 
{
systemd.user.services = {
    
  noisetorch = {
    Unit = {
      Description       =   "noisetorch";
      After             =   ["pulseaudio.service"];
    };

    Service = {
        Type            =   "simple";
        RemainAfterExit =   "yes";
        ExecStart       =   "${pkgs.noisetorch}/bin/noisetorch -i -s alsa_input.usb-Generic_TONOR_TC40_Audio_Device-00.analog-stereo -t 95";
        ExecStop        =   "${pkgs.noisetorch}/bin/noisetorch -u";
        Restart         =   "on-failure";
        RestartSec      =   "3";
    };
    Install = {
        WantedBy        =   ["default.target"];
    };
  };
};
}