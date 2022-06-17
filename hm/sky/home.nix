{ config, pkgs, stdenv, lib, ... }:

{
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    imports = [ ./dconf.nix ];
    home = {
        username = "sky";
        homeDirectory = "/home/sky";
        stateVersion = "22.05";

        packages = with pkgs; [
        # gnome3 apps
        gnome3.eog    # image viewer
        gnome3.evince # pdf reader

        # desktop look & feel
        gnome.gnome-tweaks # desktop settings

        # extensions
        gnomeExtensions.appindicator
        #unstable.gnomeExtensions.material-shell
    ];


    };
    programs = {
        home-manager.enable = true;
        git = {
            enable = true;
            userName  = "arouzing";
            userEmail = "593336a4-f160-432d-981d-34f51d9ad98d@anonaddy.me";
        };
        
    };
}