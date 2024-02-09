{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf types mkOption;
  cfg = config.local.users.test;
in {
  options.local.users.test = {
    enable = mkEnableOption "enable user test";
    password = mkOption {
      default = null;
      type = types.str;
    };
  };
  config = mkIf cfg.enable {
    programs.zsh.enable = true;
    users.users.test = {
      uid = 1001;
      isNormalUser = true;
      initialPassword = cfg.password;
      shell = pkgs.zsh;
      description = "test";
      extraGroups = ["networkmanager" "wheel" "seat"];
    };
  };
}
