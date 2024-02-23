{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.programs.guake;
in {
  options = {programs.guake = {enable = mkEnableOption "guake";};};

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [guake];

    systemd.user.services.guake = {
      # enable = true;
      Unit = {
        Description = "guake";
        After = ["graphical-session-pre.target"];
        PartOf = ["graphical-session.target"];
      };

      # Install = {  };

      Service = {
        WantedBy = ["graphical-session.target"];
        ExecStart = "${pkgs.guake}/bin/guake";
        Environment = ["DISPLAY=:0"];
        StandardOutput = "journal+console";
        StandardError = "journal+console";
        Restart = "always";
        RestartSec = "5";
      };
    };
  };
}
