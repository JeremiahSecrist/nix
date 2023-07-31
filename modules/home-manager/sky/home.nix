{
  config,
  pkgs,
  stdenv,
  lib,
  ...
}: let
  g = {myuid = "1000";};
  font = "JetBrainsMono Nerd Font";
  accent = "bd93f9";
  background = "11111B";
in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  imports = [./dconf.nix ./packages.nix ./laptop/noisetorch.nix];
  home = {
    username = "sky";
    homeDirectory = "/home/sky";
    stateVersion = "22.11";
  };
  stylix = {
    targets = {
      vscode.enable = false;
    };
  };
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      });
    })
  ];
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      height = 35;
      spacing = 4;
      modules-left = ["wlr/workspaces"];
      # modules-right = ["pulseaudio" "network" "cpu" "memory" "temperature" "battery" "clock" "tray"];
      clock = {
        timezone = "America/New_York";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format = "{:%a, %d %b, %I:%M %p}";
      };
      battery = {
        states = {
          good = 95;
          warning = 30;
          critical = 15;
        };
        format = "{capacity}% {icon}";
        format-charging = "{capacity}% ";
        format-plugged = "{capacity}% ";
        format-alt = "{time} {icon}";
        format-icons = ["" "" "" "" ""];
      };
      network = {
        format-wifi = "{essid} ({signalStrength}%) ";
        format-ethernet = "Ethernet ";
        tooltip-format = "{ifname} via {gwaddr}";
        format-linked = "{ifname} (No IP)";
        format-disconnected = "Disconnected ⚠";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
      };
      pulseaudio = {
        format = "{volume}% {icon} {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = "{icon} {format_source}";
        format-muted = "{format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = ["" "" ""];
        };
        on-click = "pavucontrol";
      };
      # tray = {
      #     spacing = 10;
      # };
      cpu = {
        format = "{usage}% ";
        tooltip = false;
      };
      memory = {
        format = "{}% ";
      };
      temperature = {
        format = "{temperatureC}°C {icon}";
        format-icons = [""];
      };
    };
    style = ''
      * {
          font-family: ${font}, FontAwesome, Roboto, Helvetica, Arial, sans-serif;
          font-size: 16px;
          color: #${accent};
      }

      window#waybar {
          background-color: rgba(43, 48, 59, 0);
          border-bottom: 3px solid rgba(100, 114, 125, 0);
          transition-property: background-color;
          transition-duration: .5s;
      }

      window#waybar.hidden {
          opacity: 0.2;
      }

      button {
          /* Use box-shadow instead of border so the text isn't offset */
          box-shadow: inset 0 -3px transparent;
          /* Avoid rounded borders under each button name */
          border: none;
          border-radius: 0;
      }

      button:hover {
          background: inherit;
          box-shadow: inset 0 -3px #ffffff;
      }

      #workspaces button {
          padding: 5px;
          background-color: transparent;
          color: #${accent};
      }

      #workspaces button:hover {
          background: rgba(0, 0, 0, 0.2);
      }

      #workspaces button.active{
          color: #${accent};
          border-radius: 10px;
          box-shadow: inset 0 -3px #${accent};
      }

      #workspaces button.urgent {
          background-color: #eb4d4b;
      }

      #mode {
          background-color: #64727D;
          border-bottom: 3px solid #ffffff;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #wireplumber,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #mpd,
      #window,
      #workspaces {
          margin-top: .70rem;
          background: #${background};
          padding: 0 1rem;
          border-radius: .75rem;
      }
      #battery{
          padding-right: 1.75rem;
      }
      #network{
          padding-right: 1.5rem;
      }
      #memory,
      #cpu{
          padding-right: 1.25rem;
      }
      #tray{
          margin-right: .5rem;
      }
      /* If workspaces is the leftmost module, omit left margin */
      .modules-left > widget:first-child > #workspaces {
          margin-left: .9rem;
      }

      .modules-right{
          margin-right: .70rem;
      }

      /* If workspaces is the rightmost module, omit right margin */
      .modules-right > widget:last-child > #workspaces {
          margin-right: .9rem;
      }

    '';
  };

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
