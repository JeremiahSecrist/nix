{
  config,
  pkgs,
  lib,
  ...
}: let
  #   inherit (lib) mkEnableOption mkIf types mkOption;
  cfg = config.services.xserver.displayManager.lemurs;

  files = import ./files.nix {
    xsessionOption = "";
    xsessionDir = "/var/run/xorg/xsession";
    inherit pkgs;
  };

  settingsFormat = pkgs.formats.toml {};

  settingsFile = settingsFormat.generate "config.toml" cfg.settings;
in {
  options.services.xserver.displayManager.lemurs = {
    enable = lib.mkEnableOption "Enables Lemur display manager";
    package = lib.mkOption {
      default = pkgs.callPackage ./lemursp.nix {};
      description = "Package used for lemurs";
    };
    settings = lib.mkOption {
      inherit (settingsFormat) type;
      default = files.settings;
      description = lib.mdDoc ''
        Configuration included in `config.toml`.

        See https://github.com/coastalwhite/lemurs/blob/main/extra/config.toml for documentation.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.dbus.enable = true;
    security.pam.services.lemurs = {};
    environment.etc = {
      "lemurs/config.toml".source = settingsFile;
      "lemurs/xsetup.sh" = {
        mode = "0555";
        text = files.xsetup;
      };
      "lemurs/wayland/hyprland" = {
        mode = "0555";
        text = ''
          #!/usr/bin/env bash
          unset DISPLAY
          ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland
          exec ${pkgs.hyprland}/bin/Hyprland
        '';
      };
    };

    systemd.services."getty@tty${toString cfg.settings.tty}".enable = false;

    systemd.defaultUnit = "graphical.target";
    systemd.tmpfiles.rules = [
      "d /var/lib/lemurs 0755 root root"
    ];
    systemd.services.lemurs = {
      description = "Lemurs";
      after = [
        "systemd-user-sessions.service"
        "plymouth-quit-wait.service"
        "getty@tty${toString cfg.settings.tty}.service"
      ];
      aliases = [
        "display-manager.service"
      ];
      conflicts = [
        "getty@tty${toString cfg.settings.tty}.service"
      ];
      environment = {
        RUST_LOG = "Trace";
        PWD = "/var/lib/lemurs";
      };
      serviceConfig = {
        # WantedBy = [
        #   "graphical.target"
        # ];
        WorkingDirectory = "/var/lib/lemurs";
        # restartIfChanged = false;
        ExecStart = "${cfg.package}/bin/lemurs";
        StandardInput = "tty";
        TTYPath = "/dev/tty${toString cfg.settings.tty}";
        TTYReset = "yes";
        TTYVHangup = "yes";
        Type = "idle";
      };
    };
  };
}
