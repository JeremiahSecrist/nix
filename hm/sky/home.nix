{ config, pkgs, ... }:

{
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    imports = [ ./dconf.nix ];
    home = {
        username = "sky";
        homeDirectory = "/home/sky";
        stateVersion = "22.05";
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