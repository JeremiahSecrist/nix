{
  config,
  pkgs,
  stdenv,
  lib,
  ...
}: let
  g = {myuid = "1000";};
in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  imports = [
    # ./dconf.nix 
    ./packages.nix ./laptop/noisetorch.nix ./waybar.nix];
  home = {
    username = "sky";
    homeDirectory = "/home/sky";
    stateVersion = "22.11";
  };
  #stylix = {
  #  targets = {
  #    vscode.enable = false;
  #  };
  #};

  #   wayland.windowManager.hyprland.enable = true;
  #  wayland.windowManager.hyprland.extraConfig = ''
  #   $mod = SUPER

  #   bind = $mod, F, exec, firefox
  #   bind = , Print, exec, grimblast copy area

  #   # workspaces
  #   # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
  #   ${builtins.concatStringsSep "\n" (builtins.genList (
  #       x: let
  #         ws = let
  #           c = (x + 1) / 10;
  #         in
  #           builtins.toString (x + 1 - (c * 10));
  #       in ''
  #         bind = $mod, ${ws}, workspace, ${toString (x + 1)}
  #         bind = $mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}
  #       ''
  #     )
  #     10)}

  #   # ...
  # '';
  home.file.wallpapers = {
    recursive = true;
    source = ./wallpapers;
    target = "./Pictures/wallpapers";
  };
  xdg.enable = true;
  # services.easyeffects = {
  #     enable = true;
  #     preset = "noisereduc";
  #   };
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableExtraSocket = true;
    enableZshIntegration = true;
    enableScDaemon = true;
    sshKeys = ["8D53CA91572B3252096210F0A5D58142765E3114"];
    pinentryFlavor = "gnome3";
    defaultCacheTtl = 345600;
    defaultCacheTtlSsh = 345600;
    maxCacheTtl = 345600;
    maxCacheTtlSsh = 345600;
    extraConfig = "\n";
  };
  wayland.windowManager.hyprland.systemdIntegration = true;
  wayland.windowManager.hyprland.xwayland.hidpi = true;
  programs = {
    swaylock.enable = true;

    home-manager.enable = true;
    # zellij = {
    #   enable = true;

    # };
    helix = {
      enable = true;
    };

    vscode = {
      enable = true;
      mutableExtensionsDir = true;
    };

    gpg = {
      mutableTrust = false;
      mutableKeys = false;
      publicKeys = [
        {
          me = {
            trust = 5;
            source = ./publickeys.gpg;
          };
        }
      ];
    };
    ssh = {
      enable = true;
      compression = true;
      # forwardAgent = true;
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          forwardAgent = false;
        };
        "*.tail3f4f1.ts.net" = {
          user = "ops";
        };
      };
    };
    direnv = {
      enableZshIntegration = true;
      enable = true;
    };

    git = {
      enable = true;
      userName = "Jermeiah S";
      userEmail = "owner@arouzing.xyz";
      signing = {
        key = "59472c1F0709FBA9";
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
        share = true;
        path = "$ZDOTDIR/.zsh_history";
        save = 10000000;
      };

      initExtra = ''
        function set_win_title(){
            echo -ne "\033]0; $(basename "$PWD") \007"
        }
        bindkey "^[[3~" delete-char
        bindkey "^H" backward-kill-word
        bindkey '^[[3;6~' kill-word
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
        ${lib.optionalString config.services.gpg-agent.enable ''
          export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
        ''}
        # eval "$(zellij setup --generate-auto-start zsh)"
      '';
      envExtra = ''
        starship_precmd_user_func="set_win_title"
        precmd_functions+=(set_win_title)
      '';
      localVariables = {
        EDITOR = "hx";
      };
      shellAliases = {
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
      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.5.0";
            sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
          };
        }
      ];
    };
  };
}
