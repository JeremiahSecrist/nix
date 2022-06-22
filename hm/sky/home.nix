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
        # desktop look & feel
        gnome.gnome-tweaks # desktop settings
        # extensions
        gnomeExtensions.appindicator
        # CLI
        btop
        dconf2nix
        nano
        git
        comma
        # protonvpn-cli

        # Desktop
        distrobox
        cryptomator
        firefox-wayland
        yubioath-desktop
        vscode-fhs
        spotify
        discord
        gnupg

    ];
    file = {
        u2fKeys = {
            target = ".config/Yubico/u2f_keys";
            text = "sky:TCSOBHxXpt4Y5ObYuAIHBwSwzbFKo28k0uUzlMrmX/pmBQ1HMLRbdUjv5OdmQDdzRznD0bDbJa1KWRiVX4gR9w==,z+nivJZ8lfzmxWDODA5GqHbRz1Si+aXklml/NfNvDgTS80wjbPvgzWomRQN551dqpHcqRmUygLbcXFhwy0J0lQ==,es256,+presence";
        };
    };

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