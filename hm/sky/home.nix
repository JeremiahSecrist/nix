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
      tldr
      sshfs
      nixfmt
      cmatrix
      noisetorch
      # protonvpn-cli

      # Desktop
      rustdesk
      distrobox
      cryptomator
      firefox-wayland
      yubioath-desktop
      vscode-fhs
      spotify
      discord
      gnupg
      virt-manager
      # development
      terraform

    ];
  };
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
    enableSshSupport = true;
    enableExtraSocket = true;
    defaultCacheTtl = 34560000;
    defaultCacheTtlSsh = 34560000;
    maxCacheTtl = 34560000;
    maxCacheTtlSsh = 34560000;
  };
  programs = {
    home-manager.enable = true;
    gpg = {
      mutableTrust = true;
      mutableKeys = true;
      publicKeys = [{
        me = {
          trust = 5;
          source = ./publickeys.gpg;
        };
      }];
    };
    ssh = {
      enable = true;
      compression = true;
      forwardAgent = true;
      extraOptionOverrides = {
        "IdentityAgent" = "/run/user/1000/gnupg/S.gpg-agent.ssh";
      };
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          forwardAgent = false;
        };
        "10.27.27.226" = {
          user = "admin";
          remoteForwards = [
            {
              host.address = "/run/user/1000/gnupg/S.gpg-agent";
              bind.address = "/run/user/1000/gnupg/S.gpg-agent";
            }
            {
              host.address = "/run/user/1000/gnupg/S.gpg-agent.extra";
              bind.address = "/run/user/1000/gnupg/S.gpg-agent.extra";
            }
          ];
        };
      };
    };
    direnv = {
      enableZshIntegration = true;
      enable = true;
    };
    git = {
      enable = true;
      userName = "arouzing";
      userEmail = "owner@arouzing.xyz";
      signing = {
        key = "71F252936D785219";
        signByDefault = true;
      };
    };

    starship.enable = true;

    zsh = {
      enable = true;
      history = { save = 10000000; };
      initExtra = ''
        function set_win_title(){
            echo -ne "\033]0; $(basename "$PWD") \007"
        }
        bindkey "^[[3~" delete-char
        gpg-connect-agent reloadagent /bye > /dev/null
      '';
      envExtra = ''
        starship_precmd_user_func="set_win_title"
        precmd_functions+=(set_win_title)
      '';
      shellAliases = {
        nrs = "pushd ~/nix && make switch ; popd";
        reagent = "gpg-connect-agent reloadagent /bye";
        fucking = "sudo";
      };
      enableCompletion = true;
      completionInit = ''
        autoload -U compinit && zstyle ':completion:*' menu select && zmodload zsh/complist && compinit && _comp_options+=(globdots)	
      '';
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      autocd = true;
      plugins = [{
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
        };
      }];
    };
  };
}
