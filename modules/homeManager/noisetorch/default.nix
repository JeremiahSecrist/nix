{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.personal.noisetorch;
  settingsFormat = pkgs.formats.toml {};
  settingsFile = settingsFormat.generate "config.toml" cfg.settings;
in {
  options.personal.noisetorch = {
    enable = mkEnableOption "enables noisetorch service for user";
    settings = {
      Threshold = mkOption {
        default = 80;
        type = types.int;
      };
      DisplayMonitorSources = mkOption {
        default = false;
        type = types.bool;
      };
      EnableUpdates = mkOption {
        default = false;
        type = types.bool;
      };
      FilterInput = mkOption {
        default = cfg.settings.LastUsedInput != "";
        type = types.bool;
      };
      FilterOutput = mkOption {
        default = cfg.settings.LastUsedOutput != "";
        type = types.bool;
      };
      LastUsedInput = mkOption {
        default = "";
        type = types.str;
      };
      LastUsedOutput = mkOption {
        default = "";
        type = types.str;
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = (0 <= cfg.settings.Threshold) && (cfg.settings.Threshold <= 95);
        message = "personal.noisetorch.threshold valid values: 0-95";
      }
    ];
    # home.file.noisetorch-config = {
    #   target = ".config/noisetorch/config.toml";
    #   source = settingsFile;
    # };
    systemd.user.services = {
      noisetorch = {
        Unit = {
          Description = "noisetorch";
          After = ["pulseaudio.service"];
        };

        Service = {
          Type = "simple";
          RemainAfterExit = "yes";
          ExecStart = "${pkgs.noisetorch}/bin/noisetorch -i";
          ExecStop = "${pkgs.noisetorch}/bin/noisetorch -u";
          Restart = "on-failure";
          RestartSec = "3";
        };
        Install = {WantedBy = ["default.target"];};
      };
    };
  };
}
