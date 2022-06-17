_: { config, pkgs, ... }: 
{
security = {
    pam = {
      u2f = {
        enable = true;
        control = "sufficient";
        cue = true;
      };
      services = {
        login.u2fAuth = true;
        gdm.u2fAuth = true;
        slock.u2fAuth = true;
      };
    };
  };
}