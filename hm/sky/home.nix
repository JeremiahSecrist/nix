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
    };
    
    programs                    = {
        home-manager.enable     = true;
        direnv = {
            enableZshIntegration    = true;
            enable                  = true;
        };
        git                     = {
            enable              = true;
            userName            = "arouzing";
            userEmail           = "owner@arouzing.xyz";
            signing             = {
                key             = "71F252936D785219";
                signByDefault   = true;
            };
        };
        starship.enable = true;
        
        zsh = {
            enable                      = true;
            history     = {
                save    = 10000000;
            };
            initExtra                    = ''
            function set_win_title(){
                echo -ne "\033]0; $(basename "$PWD") \007"
            }
            starship_precmd_user_func="set_win_title"

            '';
            enableCompletion            = true;
            completionInit              = ''
            autoload -U compinit && zstyle ':completion:*' menu select && zmodload zsh/complist && compinit && _comp_options+=(globdots)	
            '';
            enableAutosuggestions       = true;
            enableSyntaxHighlighting    = true;
            autocd                      = true;
        };    
    };
}