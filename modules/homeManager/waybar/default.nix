{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption types;
  font = "JetBrainsMono Nerd Font";
  accent = "bd93f9";
  background = "11111B";
  cfg = config.personal.desktop.waybar;
in {
  options.personal.desktop.waybar.enable = mkEnableOption "";
  config = mkIf cfg.enable {
    xdg.configFile."swaync/config.json".text = builtins.toJSON {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      "control-center-layer" = "top";
      hode-on-action = "false";
      control-center-positionX = "right";
      control-center-positionY = "top";
      control-center-margin-top = 30;
      # control-center-layer = "overlay";
      layer-shell = true;
      fit-to-screen = false;
    };
    systemd.user.services.swaync = {
      Unit.Description = "Notifications center for sway";
      Unit.PartOf = ["graphical-session.target"];
      Install.WantedBy = ["graphical-session.target" "hyprland-session.target"];
      Service = {
        ExecStart = "${pkgs.swaynotificationcenter}/bin/swaync";
        Restart = "always";
        RestartSec = "3";
      };
    };

    xdg.dataFile."dbus-1/services/swaync.service".text = ''
      [D-BUS Service]
      Name=org.freedesktop.Notification
      Exec=${pkgs.swaynotificationcenter}/bin/swaync
      SystemdService=swaync.service
    '';
    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        # target = "hyprland-session.target";
      };
      settings.mainBar = import ./mainBar.nix {inherit pkgs;};
      style = builtins.readFile ./style.css;
    };
  };
}
