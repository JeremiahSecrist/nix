{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.personal.desktop.hyprland;
in {
  options.personal.desktop.hyprland = {
    enable = lib.mkEnableOption "This enables hyprland desktop";
  };

  config = lib.mkIf cfg.enable {
    security.pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
    environment.systemPackages = with pkgs; [
      # xfce.thunar

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
    hardware.opengl.extraPackages = [
      pkgs.amdvlk
    ];
    hardware.opengl.extraPackages32 = [
      pkgs.driversi686Linux.amdvlk
    ];
    services.devmon.enable = true;
    services.gvfs.enable = true;
    services.udisks2.enable = true;

    services.xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "";
    };

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk];
    };
  };
}
