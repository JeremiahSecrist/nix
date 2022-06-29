_: { config, pkgs, lib, ... }: 
{
services.pcscd.enable = true;
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
