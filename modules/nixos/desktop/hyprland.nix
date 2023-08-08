{
  config,
  pkgs,
  lib,
  ...
}: let
  dmcfg = config.services.xserver.displayManager;
  cfg = config.custom.desktop.hyprland;
  gduser = config.services.greetd.settings.default_session.user;
in {
  options.custom.desktop.hyprland = {
    enable = lib.mkEnableOption "This enables hyprland desktop";
  };

  config = lib.mkIf cfg.enable {
    xdg.mime = {
      defaultApplications = {
        "inode/directory" = "thunar.desktop";
      };
      removedAssociations = {
        "inode/directory" = "nemo.desktop";
      };
    };
    security.pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
    environment.systemPackages = with pkgs; [
      # xfce.thunar
      pw-volume
      grim
      slurp
      pavucontrol
      rofi
      inotify-tools
      wayland-protocols
      mako
      wl-clipboard
      brightnessctl
    ];
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    fonts.fonts = with pkgs; [
      font-awesome
      (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono" "Iosevka"];})
    ];
    programs = {
      thunar.enable = true;
      steam.gamescopeSession.enable = true;
      gamescope.enable = true;
      # waybar = {
      #   enable = true;
      #   package = pkgs.waybar.overrideAttrs (oa: {
      #     mesonFlags = (oa.mesonFlags or []) ++ ["-Dexperimental=true"];
      #   });
      # };
      hyprland = {
        enable = true;
        xwayland = {
          enable = true;
          hidpi = true;
        };
      };
      xwayland.enable = true;
    };
    services.devmon.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --asterisks --remember -s ${dmcfg.sessionData.desktops}/share/wayland-sessions";
          user = "greeter";
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d /var/cache/tuigreet/ 0755 greeter ${gduser} - -"
    ];

    services.xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "";
    };

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland 
        pkgs.xdg-desktop-portal
        ];
    };
  };
}
