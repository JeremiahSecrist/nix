{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.custom.desktop.hyprland;
in {

  options.custom.desktop.hyprland = {
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
      displayManager = {
        lemurs.enable = true;
        # gdm.enable = true;
        # gdm.wayland = true;
        # defaultSession = lib.mkDefault "hyperland";
      };
    };
    # services.greetd = {
    #   enable = true;
    #   settings = rec {
    #     initial_session = {
    #       command = "Hyprland";
    #       user = "sky";
    #     };
    #     default_session = initial_session;
    #   };
    # };

    environment.etc."greetd/environments".text = ''
      Hyprland
    '';

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk];
    };
  };
}
