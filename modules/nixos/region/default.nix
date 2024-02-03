{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkDefault mkIf types;
  cfg = config.personal.region;
  # ops = options.base.defaults.region;
in {
  options.personal.region = {
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
    time.timeZone = mkDefault cfg.timeZone;

    i18n = rec {
      defaultLocale = mkDefault cfg.locale;
      supportedLocales = [
        "en_US.UTF-8/UTF-8"
        "en_GB.UTF-8/UTF-8"
        "nl_NL.UTF-8/UTF-8"
        "nl_NL/ISO-8859-1"
      ];
      # extraLocaleSettings = {
      #   LC_ADDRESS = defaultLocale;
      #   LC_IDENTIFICATION = defaultLocale;
      #   LC_MEASUREMENT = defaultLocale;
      #   LC_MONETARY = defaultLocale;
      #   LC_NAME = defaultLocale;
      #   LC_NUMERIC = defaultLocale;
      #   LC_PAPER = defaultLocale;
      #   LC_TELEPHONE = defaultLocale;
      #   LC_TIME = defaultLocale;
      # };
    };
  };
}
