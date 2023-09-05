{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  dmcfg = config.services.xserver.displayManager;
  cfg = config.personal.desktop.hyprland;
  gduser = config.services.greetd.settings.default_session.user;
in {
  imports = [
    ../displayManager/tuigreet
  ];
  options.personal.desktop.hyprland = {
    enable = lib.mkEnableOption "This enables hyprland desktop";
  };

  config = lib.mkIf cfg.enable {
    xdg.mime = {
      defaultApplications = {
        "inode/directory" = "thunar.desktop";
        "application/pdf" = "zathura.desktop";
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
      swaynotificationcenter
      swaybg
      (pkgs.writeScriptBin "xterm" "${kitty}/bin/kitty \"$@\"")
      waybar
      wofi
      pw-volume
      swaynotificationcenter
      pavucontrol
      rofi
      inotify-tools
      kitty
      wayland-protocols
      wl-clipboard
      ydotool
      brightnessctl
      networkmanagerapplet
      bluetuith
      termusic
      nwg-displays
      wlr-randr
      hyprland-autoname-workspaces
      sway-contrib.grimshot
    ];
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    fonts.packages = with pkgs; [
      font-awesome
      (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono" "Iosevka"];})
    ];
    programs = {
      thunar = {
        enable = true;
      };
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
          #   # hidpi = true;
        };
      };
      # xwayland.enable = true;
    };
    services.devmon.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;

    personal.desktop.displayManager.tuigreet.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
}
