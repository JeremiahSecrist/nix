_: { config, pkgs, lib, ... }: 
{
# services.udev.extraRules = ''
# ACTION!="add|change", GOTO="fido_end"
# KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0407", TAG+="uaccess"
# LABEL="fido_end"'';
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
