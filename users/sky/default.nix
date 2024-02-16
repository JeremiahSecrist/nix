{
  config,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  imports = [
    # ./dconf.nix
    ./packages.nix
  ];
  local = {
    # desktop = {
    #   # hyprland.enable = true;
    #   # waybar.enable = true;
    # };
    # noisetorch = {
    #   enable = true;
    #   settings.LastUsedInput = "alsa_input.usb-Generic_TONOR_TC40_Audio_Device-00.iec958-stereo";
    # };
  };
  home = rec {
    username = "sky";
    homeDirectory = "/home/${username}";
    stateVersion = "22.11";
    sessionVariables = {
      BROWSER = "firefox";
      EDITOR = "hx";
      # MOZ_ENABLE_WAYLAND = 1;
      TERMINAL = "kitty";
      # XDG_CURRENT_DESKTOP = "hyprland";
      DIRENV_LOG_FORMAT = "";
      # TERM = "kitty";
    };
    # pointerCursor = {
    #   package = pkgs.bibata-cursors;
    #   name = "Bibata-Modern-Classic";
    #   size = 22;
    #   # x11.enable = true;
    #   gtk.enable = true;
    # };
  };
  # programs.anyrun = {
  #   enable = true;
  #   config = {
  #     plugins = [
  #       "${inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/libapplications.so"
  #       "${inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/libkidex.so"
  #     ];
  #     width = {fraction = 0.3;};
  #     # position = "top";
  #     # verticalOffset = { absolute = 0; };
  #     hideIcons = false;
  #     ignoreExclusiveZones = false;
  #     layer = "overlay";
  #     hidePluginInfo = false;
  #     closeOnClick = false;
  #     showResultsImmediately = true;
  #     maxEntries = null;
  #   };
  #   extraCss = ''
  #     .some_class {
  #       background: red;
  #     }
  #   '';

  #   extraConfigFiles."some-plugin.ron".text = ''
  #     Config(
  #       // for any other plugin
  #       // this file will be put in ~/.config/anyrun/some-plugin.ron
  #       // refer to docs of xdg.configFile for available options
  #     )
  #   '';
  # };
  # dconf = {
  #   enable = true;
  #   settings = {
  #     "org/virt-manager/virt-manager/connections" = {
  #       autoconnect = ["qemu:///system"];
  #       uris = ["qemu:///system"];
  #     };
  #     "org/gnome/desktop/wm/preferences" = {
  #       auto-raise = true;
  #     };
  #     "org/gnome/desktop/interface" = {
  #       color-scheme = "prefer-dark";
  #     };
  #     "org/gnome/mutter" = {
  #       experimental-features = ["scale-monitor-framebuffer"];
  #     };
  #   };
  # };
  # gtk = {
  #   enable = true;
  #   font.name = "Victor Mono SemiBold 12";
  #   theme = {
  #     name = "spacx";
  #     package = pkgs.spacx-gtk-theme;
  #   };
  #   iconTheme = {
  #     name = "rose-pine";
  #     package = pkgs.rose-pine-icon-theme;
  #   };
  # };

  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        end_of_line = "lf";
        insert_final_newline = true;
        trim_trailing_whitespace = true;
        charset = "utf-8";
      };
      "*.lock" = {
        indent_size = "unset";
      };
      "*.{json,lock,md,nix,pl,pm,py,rb,sh,xml}" = {
        indent_style = "space";
      };
      "*.gpg" = {
        indent_size = "unset";
        insert_final_newline = "unset";
      };
    };
  };
  # programs.kitty = {
  #   enable = true;
  #   keybindings = {
  #     # "ctrl+left release grabbed ungrabbed" = "mouse_handle_click link";
  #   };
  #   shellIntegration.enableZshIntegration = config.programs.zsh.enable;
  #   settings = {
  #     confirm_os_window_close = 0;
  #     detect_urls = true;
  #     enable_audio_bell = false;
  #     open_url_with = "${pkgs.firefox-beta}/bin/firefox";
  #   };
  #   extraConfig = ''
  #   '';
  # };

  home.file.wallpapers = {
    recursive = true;
    source = ./files/wallpapers;
    target = "./Pictures/wallpapers";
  };
  xdg.enable = true;
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;
  # xdg.mimeApps = {
  #   defaultApplications."application/pdf" = ["zathura.desktop"];
  # };
  # services.easyeffects = {
  #     enable = true;
  #     preset = "noisereduc";
  #   };
  services.gpg-agent = {
    # enable = true;
    enableSshSupport = true;
    enableExtraSocket = true;
    enableZshIntegration = true;
    enableScDaemon = true;
    sshKeys = ["8D53CA91572B3252096210F0A5D58142765E3114"];
    # pinentryFlavor = "gnome3";
    # defaultCacheTtl = 345600;
    # defaultCacheTtlSsh = 345600;
    # maxCacheTtl = 345600;
    # maxCacheTtlSsh = 345600;
    # extraConfig = "disable-ccid\n";
  };
  services.gnome-keyring = {
    components = ["secrets"];
    enable = true;
  };
  programs = {
    firefox = {
      enable = true;
      package = pkgs.firefox-beta;
      profiles.default = {
        isDefault = true;
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          sponsorblock
          ublock-origin
          bitwarden
          # startpage-private-search
        ];
        search = {
          force = true;
          order = [
            "startpage"
          ];
          default = "startpage";
          engines = {
            "startpage" = {
              keyword = "sp";
              urls = [
                {
                  template = "https://www.startpage.com/en/search?query={searchTerms}";
                }
              ];
            };
          };
        };
        settings = {
          "app.normandy.first_run" = false;
          "browser.aboutConfig.showWarning" = false;
          "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.pinned" = [];
          "browser.ping-centre.telemetry" = false;
          "browser.tabs.crashReporting.sendReport" = false;
          "browser.theme.content-theme" = 2;
          "browser.theme.toolbar-theme" = 2;
          "browser.urlbar.suggest.pocket" = false;
          "devtools.onboarding.telemetry.logged" = false;
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
          "extensions.pocket.bffRecentSaves" = false;
          "extensions.pocket.enabled" = false;
          "identity.fxaccounts.enabled" = false;
          # "media.ffmpeg.vaapi.enabled" = true;
          # "media.mediasource.webm.enabled" = false;
          "network.trr.mode" = 2;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.server" = "";
          "toolkit.telemetry.unified" = false;
        };
      };
    };
    # swaylock = {
    #   enable = true;
    #   settings = {
    #     indicator-idle-visible = true;
    #     image = "$HOME/Pictures/wallpapers/Darth-VaderSci-Fi-Star-Wars-4k-Ultra-HD-Wallpaper.jpg";
    #   };
    # };
    home-manager.enable = true;
    # zathura = {
    #   enable = true;
    #   options = {
    #     selection-clipboard = "clipboard";
    #   };
    # };
    # zellij = {
    #   enable = true;

    # };
    helix = {
      enable = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd"
      ];
    };
    vscode = {
      enable = true;
      # mutableExtensionsDir = true;
    };

    gpg = {
      # enable = true;
      mutableTrust = true;
      mutableKeys = false;
      publicKeys = [
        {
          trust = "ultimate";
          source = ./files/publickeys.gpg;
        }
      ];
    };
    ssh = {
      enable = true;
      compression = true;
      forwardAgent = true;
      extraConfig = "PKCS11Provider ${pkgs.tpm2-pkcs11}/lib/libtpm2_pkcs11.so\n";
      matchBlocks = {
        "107.172.92.84" = {
          host = "107.172.92.84";
          forwardAgent = true;
          # extraOptions = {
          #   AddKeysToAgent = "yes";
          #   # RemoteForward = "/run/user/1000/gnupg/ /run/user/1000/gnupg/";
          # };
        };
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
      extraConfig = {
        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingkey = "${pkgs.writeText "mykey.pub" "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBA9i9HoP7X8Ufzz8rAaP7Nl3UOMZxQHMrsnA5aEQfpTyIQ1qW68jJ4jGK5V6Wv27MMc3czDU1qfFWIbGEWurUHQ="}";
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
        # eval "$(zellij setup --generate-auto-start zsh)"
        # export SSH_AUTH_SOCK=$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)
      '';
      envExtra = ''
        starship_precmd_user_func="set_win_title"
        precmd_functions+=(set_win_title)
      '';
      localVariables = {
        #   EDITOR = "hx";
        TERM = "kitty";
      };
      shellAliases = {
        reagent = "gpg-connect-agent reloadagent /bye";
        fucking = "sudo";
        tssh = "ssh-add -s ${pkgs.tpm2-pkcs11}/lib/libtpm2_pkcs11.so";
      };
      enableCompletion = true;
      completionInit = ''
        compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION" && autoload -U compinit && zstyle ':completion:*' menu select && zmodload zsh/complist && compinit && _comp_options+=(globdots)
      '';
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
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
