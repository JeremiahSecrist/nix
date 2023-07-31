{
  config,
  pkgs,
  lib,
}: let
  inherit (lib) enableOption mkIf types mkOption;

  cfg = config.services.xserver.displayManager.lemurs;

  settingsFormat = pkgs.formats.toml {};

  settingsFile = settingsFormat.generate "config.toml" cfg.settings;
in {
  options.services.xserver.displayManager.lemurs = {
    enable = enableOption "Enables Lemur display manager";
    package = mkOption {
      default = pkgs.lemurs;
      description = "Package used for lemurs";
    };
    settings = mkOption {
      inherit (settingsFormat) type;
      default = {
        tty = 2;
        x11_display = ":1";
        xserver_timeout_secs = 60;
        main_log_path = "/var/log/lemurs.log";
        client_log_path = "/var/log/lemurs.client.log";
        xserver_log_path = "/var/log/lemurs.xorg.log";
        do_log = true;
        pam_service = "lemurs";
        shell_login_flag = "short";
        focus_behaviour = "default";
        background = {
          show_background = false;
        };
        background.style = {
          border_color = "white";
          show_border = true;
          color = "black";
        };

        power_controls = {
          allow_shutdown = true;
          shutdown_hint = "Shutdown %key%";
          shutdown_hint_color = "dark gray";
          shutdown_hint_modifiers = "";
          shutdown_key = "F1";
          shutdown_cmd = "systemctl poweroff -l";
          allow_reboot = true;
          reboot_hint = "Reboot %key%";
          reboot_hint_color = "dark gray";
          reboot_hint_modifiers = "";
          reboot_key = "F2";
          reboot_cmd = "systemctl reboot -l";
          hint_margin = 2;
        };

        environment_switcher = {
          switcher_visibility = "visible";
          toggle_hint = "Switcher %key%";
          toggle_hint_color = "dark gray";
          toggle_hint_modifiers = "";
          include_tty_shell = false;
          remember = true;
          show_movers = true;
          mover_color = "dark gray";
          mover_modifiers = "";
          mover_color_focused = "orange";
          mover_modifiers_focused = "bold";
          left_mover = "<";
          right_mover = ">";
          mover_margin = 1;
          show_neighbours = true;
          neighbour_color = "dark gray";
          neighbour_modifiers = "";
          neighbour_color_focused = "gray";
          neighbour_modifiers_focused = "";
          neighbour_margin = 1;
          selected_color = "gray";
          selected_modifiers = "underlined";
          selected_color_focused = "white";
          selected_modifiers_focused = "bold";
          max_display_length = 8;
          no_envs_text = "No environments...";
          no_envs_color = "white";
          no_envs_modifiers = "";
          no_envs_color_focused = "red";
          no_envs_modifiers_focused = "";
        };

        username_field = {
          remember = true;
          style = {
            show_title = true;
            title = "Login";
            title_color = "white";
            content_color = "white";
            title_color_focused = "orange";
            content_color_focused = "orange";
            show_border = true;
            border_color = "white";
            border_color_focused = "orange";
            use_max_width = true;
            max_width = 48;
          };
        };
        password_field = {
          content_replacement_character = "*";
          style = {
            show_title = true;
            title = "Password";
            title_color = "white";
            content_color = "white";
            title_color_focused = "orange";
            content_color_focused = "orange";
            show_border = true;
            border_color = "white";
            border_color_focused = "orange";
            use_max_width = true;
            max_width = 48;
          };
        };
      };
      description = lib.mdDoc ''
        Configuration included in `config.toml`.

        See https://github.com/coastalwhite/lemurs/blob/main/extra/config.toml for documentation.
      '';
    };
  };

  config = mkIf cfg.enable {
    security.pam.services.lemurs = {
      text = ''
        #%PAM-1.0
        auth        include    login
        account     include    login
        session     include    login
        password    include    login
      '';
    };

    systemd.services.lemurs = {
      description = "Lemurs";
      after = ["systemd-user-sessions.service" "plymouth-quit-wait.service" "getty@tty${cfg.settings.tty}.service"];
      aliases = ["display-manager.service"];

      serviceConfig = {
        ExecStart = "${pkgs.lemurs}/bin/lemurs --config ${settingsFile}";
        StandardInput = "tty";
        TTYPath = "/dev/tty${cfg.settings.tty}";
        TTYReset = "yes";
        TTYVHangup = "yes";
        Type = "idle";
      };
    };
  };
}
