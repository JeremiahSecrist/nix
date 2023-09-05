{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.personal.desktop.hyprland;
in {
  options.personal.desktop.hyprland = {
    enable = mkEnableOption "";
    settings = mkOption {
      default = import ./settings.nix {inherit config;};
      type = types.attrs;
    };
  };
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      settings = cfg.settings;
    };
  };
}
