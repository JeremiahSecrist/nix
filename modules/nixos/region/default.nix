{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkDefault mkIf types;
  cfg = config.local.region;
  # ops = options.base.defaults.region;
in {
  options.local.region = {
    enable = mkEnableOption "enables defaults for region";
    locale = mkOption {
      default = "en_US.utf8";
      type = types.str;
    };
    timeZone = mkOption {
      default = "America/New_York";
      type = types.str;
    };
  };
  config = mkIf cfg.enable {
    systemd.extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';

    time.timeZone = mkDefault cfg.timeZone;

    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
}
