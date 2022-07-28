_: { config, pkgs, lib, ... }: 
{
services.pcscd.enable = true;
security.pam.services.gdm.u2fAuth = true;
hardware.u2f.enable = true;
security = {
    pam = {
      u2f = {
        enable = true;
        control = "sufficient";
        cue = true;
      };
    };
  };
}
