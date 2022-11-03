{ config, pkgs, stdenv, lib, ... }:
let g = { myuid = "1000"; };
in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  imports = [ ./dconf.nix ./packages.nix ];
  home = {
    username = "sky";
    homeDirectory = "/home/sky";
    stateVersion = "22.05";
  };
  file.wallpapers = {
    recusive = true;
    source = ./wallpapers ;
    target = Pictures/wallpapers
  };
  xdg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableExtraSocket = true;
    enableZshIntegration = true;
    sshKeys = [ "8D53CA91572B3252096210F0A5D58142765E3114" ];
    pinentryFlavor = "gnome3";
    defaultCacheTtl = 345600;
    defaultCacheTtlSsh = 345600;
    maxCacheTtl = 345600;
    maxCacheTtlSsh = 345600;
    extraConfig = "\n";
  };
  programs = {
    home-manager.enable = true;
    vscode = {
      enable = true;
      mutableExtensionsDir = true;
    };
    gpg = {
      mutableTrust = false;
      mutableKeys = false;
      publicKeys = [{
        me = {
          trust = "5";
          source = ./publickeys.gpg;
        };
      }];
    };
    ssh = {
      enable = true;
      compression = true;
      forwardAgent = true;
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          forwardAgent = false;
        };
        "cache.local.arouzing.win" = {
          hostname = "cache.local.arouzing.win";
          user = "admin";
          identityFile = "/home/sky/.ssh/arouzing@gitlab";
        };
        "10.27.27.226" = {
          user = "admin";
          remoteForwards = [
            {
              host.address = "/run/user/${g.myuid}/gnupg/S.gpg-agent";
              bind.address = "/run/user/${g.myuid}/gnupg/S.gpg-agent";
            }
            {
              host.address = "/run/user/${g.myuid}/gnupg/S.gpg-agent.extra";
              bind.address = "/run/user/${g.myuid}/gnupg/S.gpg-agent.extra";
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
      userName = "Arouzing";
      userEmail = "owner@arouzing.xyz";
      signing = {
        key = "71F252936D785219";
        signByDefault = true;
      };
      diff-so-fancy.enable = true;
      lfs.enable = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      history = {
        path = "$ZDOTDIR/.zsh_history";
        save = 10000000;
      };
      initExtra = ''
        function set_win_title(){
            echo -ne "\033]0; $(basename "$PWD") \007"
        }
        bindkey "^[[3~" delete-char
        unset SSH_AGENT_PID
        if [ "''${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
          export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
        fi
        gpg-connect-agent /bye > /dev/null
      '';
      envExtra = ''
        starship_precmd_user_func="set_win_title"
        precmd_functions+=(set_win_title)
      '';
      shellAliases = {
        nru = "pushd ~/nix && nix flake update ; popd";
        nrs = "pushd ~/nix && make switch ; popd";
        nrc = "pushd ~/nix && make clean ; popd";
        nrb = "pushd ~/nix && make boot ; popd";
        reagent = "gpg-connect-agent reloadagent /bye";
        fucking = "sudo";
      };
      enableCompletion = true;
      completionInit = ''
        compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION" && autoload -U compinit && zstyle ':completion:*' menu select && zmodload zsh/complist && compinit && _comp_options+=(globdots)	
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
