{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.personal.noisetorch;
in {
  options.personal.noisetorch = {
    enable = mkEnableOption "enables noist torch service for user";
    device = mkOption {
      default = "";
      type = types.str;
    };
    threshold = mkOption {
      default = 95;
      type = types.int;
    };
  };
  config = mkIf cfg.enable {
    systemd.user.services = {
      noisetorch = {
        Unit = {
          Description = "noisetorch";
          After = ["pulseaudio.service"];
        };

        Service = {
          Type = "simple";
          RemainAfterExit = "yes";
          ExecStart = "${pkgs.noisetorch}/bin/noisetorch -i -s ${cfg.device} -t ${builtins.toString cfg.threshold}";
          ExecStop = "${pkgs.noisetorch}/bin/noisetorch -u";
          Restart = "on-failure";
          RestartSec = "3";
        };
        Install = {WantedBy = ["default.target"];};
      };
    };
  };
}
