{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf types mkOption;
  cfg = config.personal.users.sky;
in {
  options.personal.users.sky = {
    enable = mkEnableOption "enable user sky";
    password = mkOption {
      default = null;
      type = types.str;
    };
  };
  config = mkIf cfg.enable {
    programs.zsh.enable = true;
    users.users.sky = {
      uid = 1000;
      isNormalUser = true;
      initialPassword = cfg.password;
      shell = pkgs.zsh;
      description = "sky";
      extraGroups = ["networkmanager" "wheel" "seat"];
    };
  };
}
