{ config, pkgs, ... }:

{
programs.xwayland.enable = true;
hardware.opengl.enable = true ;
services.xserver = {
    desktopManager.gnome.enable = true;
    displayManager.gdm = {
        wayland = true;
        enable = true;
    };
};

}