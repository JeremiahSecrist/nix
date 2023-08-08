{
  config,
  pkgs,
  lib,
  ...
}: let
  font = "JetBrainsMono Nerd Font";
  accent = "bd93f9";
  background = "11111B";
in {
  programs.waybar = {
    enable = true;
    settings.mainBar = {
      height = 30;
      spacing = 4;
      layer = "top";
      modules-left = ["wlr/workspaces" "hyprland/window"];
      modules-right = ["custom/swaync" "pulseaudio" "cpu" "memory" "battery" "clock" "tray"];
      clock = {
        timezone = "America/New_York";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format = "{:%m/%d %I:%M:%p}";
      };
      "custom/swaync" = {
        tooltip = false;
        format = " ";
        format-icons = {
          notification = "<span foreground='red'><sup></sup></span>";
          none = "";
          dnd-notification = "<span foreground='red'><sup></sup></span>";
          dnd-none = "";
          inhibited-notification = "<span foreground='red'><sup></sup></span>";
          inhibited-none = "";
          dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
          dnd-inhibited-none = "";
        };
        return-type = "json";
        exec-if = "which swaync-client";
        exec = "swaync-client -swb";
        on-click = "swaync-client -t -sw";
        on-click-right = "swaync-client -d -sw";
        escape = true;
      };
      "hyprland/window" = {
        max-length = 30;
        separate-outputs = false;
      };
      "wlr/workspaces" = {
        # on-scroll-up = "hyprctl dispatch workspace e+1";
        # on-scroll-down = "hyprctl dispatch workspace e-1";
        on-click = "activate";
        format = "{name}: {icon}";
        format-icons = {
          "1" = "";
          "2" = "";
          "3" = "";
          "4" = "";
          "5" = "";
          active = "";
          default = "";
        };
        sort-by-number = true;
      };
      battery = {
        states = {
          good = 95;
          warning = 30;
          critical = 15;
        };
        format = "{capacity}% {icon} ";
        format-charging = "{capacity}%  ";
        format-plugged = "{capacity}%  ";
        format-alt = "{time} {icon} ";
        format-time = "{H}:{M}";
        format-icons = ["" "" "" "" ""];
      };
      network = {
        format-wifi = "{essid} ({signalStrength}%) ";
        format-ethernet = "Ethernet ";
        tooltip-format = "{ifname} via {gwaddr}";
        format-linked = "{ifname} (No IP)";
        format-disconnected = "Disconnected ⚠";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
      };
      pulseaudio = {
        format = "{volume}% {icon} ";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = "{icon} {format_source}";
        format-muted = "{format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = ["" "" ""];
        };
        on-click = "pavucontrol";
      };
      # tray = {
      #     spacing = 10;
      # };
      cpu = {
        format = "{usage}%  ";
        tooltip = false;
      };
      memory = {
        format = "{}%  ";
      };
      temperature = {
        format = "{temperatureC}°C {icon}";
        format-icons = [""];
      };
    };
    style = ''
      * {
        font-family: JetBrainsMono Nerd Font, FontAwesome, Roboto, Helvetica, Arial, sans-serif;
        font-size: 14px;
        font-weight: bold;
      }

      window#waybar {
          background-color: #1f2223;
          border-bottom: 8px solid #191c1d;
          color: #ebdbb2;
          transition-property: background-color;
          transition-duration: .5s;
      }

      window#waybar.hidden {
          opacity: 0.2;
      }

      window#waybar.termite {
          background-color: #3F3F3F;
      }

      window#waybar.chromium {
          background-color: #000000;
          border: none;
      }

      button {
          all: unset;
          background-color: #689d6a;
          color: #282828;
          border: none;
          border-bottom: 8px solid #518554;
          border-radius: 5px;
          margin-left: 4px;
          margin-bottom: 2px;
          font-family: JetBrainsMono Nerd Font, sans-sherif;
          font-weight: bold;
          font-size: 14px;
          padding-left: 15px;
          padding-right: 15px;
          transition: transform 0.1s ease-in-out;
      }

      button:hover {
          background: inherit;
          background-color: #8ec07c;
          border-bottom: 8px solid #76a765;
      }

      button.active {
          background: inherit;
          background-color: #7db37e;
          border-bottom: 8px solid #659a68;
      }

      #mode {
          background-color: #64727D;
          border-bottom: 3px solid #ffffff;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #wireplumber,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #custom-swaync,
      #custom-menu,
      #workspaces,
      #mpd {
          padding: 0 10px;
          color: #ffffff;
      }

      #window,
      #workspaces {
        opacity: 0.8;
        margin: 0 4px;

      }

      #workspaces button {
          border-bottom: 8px solid #518554;
          border: none;
          margin: 0 4px;
      }

      /* If workspaces is the leftmost module, omit left margin */
      .modules-left > widget:first-child > #workspaces {
          margin-left: 0;
      }

      /* If workspaces is the rightmost module, omit right margin */
      .modules-right > widget:last-child > #workspaces {
          margin-right: 0;
      }

      #window {
          background-color: #303030;
          color: #ebdbb2;
          font-family: JetBrainsMono Nerd Font, monospace;
          font-size: 15px;
          font-weight: bold;
          border: none;
          border-bottom: 8px solid #272727;
          border-radius: 5px;
          margin-bottom: 2px;
          padding-left: 10px;
          padding-right: 10px;
      }

      #custom-swaync {
          background-color: #689d6a;
          color: #282828;
          font-family: JetBrainsMono Nerd Font, monospace;
          font-size: 18px;
          font-weight: bold;
          border: none;
          border-bottom: 8px solid #518554;
          border-radius: 5px;
          margin-bottom: 2px;
          padding-left: 13px;
          padding-right: 9px;
      }

      #custom-menu {
          background-color: #689d6a;
          color: #282828;
          font-family: JetBrainsMono Nerd Font, monospace;
          font-size: 18px;
          font-weight: bold;
          border: none;
          border-bottom: 8px solid #518554;
          border-radius: 5px;
          margin-bottom: 2px;
          padding-left: 14px;
          padding-right: 8px;
      }

      #custom-powermenu {
          background-color: #e23c2c;
          color: #282828;
          font-family: JetBrainsMono Nerd Font, monospace;
          font-size: 22px;
          font-weight: bold;
          border: none;
          border-bottom: 8px solid #cc241d;
          border-radius: 5px;
          margin-bottom: 2px;
          margin-right: 4px;
          padding-left: 14px;
          padding-right: 7px;
      }

      #clock {
          background-color: #98971a;
          color: #282828;
          font-family: JetBrainsMono Nerd Font, monospace;
          font-size: 15px;
          font-weight: bold;
          border: none;
          border-bottom: 8px solid #828200;
          border-radius: 5px;
          margin-bottom: 2px;
      }

      #battery {
          background-color: #5d9da0;
          color: #282828;
          font-family: JetBrainsMono Nerd Font, monospace;
          font-size: 15px;
          font-weight: bold;
          border: none;
          border-bottom: 8px solid #458588;
          border-radius: 5px;
          margin-bottom: 2px;
      }

      @keyframes blink {
          to {
              background-color: #ffffff;
              color: #000000;
          }
      }

      #battery.critical:not(.charging) {
          background-color: #e23c2c;
          color: #1d2021;
          font-family: JetBrainsMono Nerd Font, monospace;
          font-size: 15px;
          font-weight: bold;
          border: none;
          border-bottom: 8px solid #cc241d;
          border-radius: 5px;
          margin-bottom: 2px;
      }

      label:focus {
          background-color: #000000;
      }

      #cpu {
          background-color: #689d6a;
          color: #282828;
          font-family: JetBrainsMono Nerd Font, monospace;
          font-size: 15px;
          font-weight: bold;
          border: none;
          border-bottom: 8px solid #518554;
          border-radius: 5px;
          margin-bottom: 2px;
      }

      #memory {
          background-color: #c8779b;
          color: #282828;
          font-family: JetBrainsMono Nerd Font, monospace;
          font-size: 15px;
          font-weight: bold;
          border: none;
          border-bottom: 8px solid #b16286;
          border-radius: 5px;
          margin-bottom: 2px;
      }

      #disk {
          background-color: #964B00;
      }

      #backlight {
          background-color: #98bbad;
          color: #282828;
          font-family: JetBrainsMono Nerd Font, monospace;
          font-size: 15px;
          font-weight: bold;
          border: none;
          border-bottom: 8px solid #80a295;
          border-radius: 5px;
          margin-bottom: 2px;
      }

      #network {
          background-color: #2980b9;
      }

      #network.disconnected {
          background-color: #f53c3c;
      }

      #pulseaudio {
          background-color: #f2b13c;
          color: #282828;
          font-family: JetBrainsMono Nerd Font, monospace;
          font-size: 15px;
          font-weight: bold;
          border: none;
          border-bottom: 8px solid #d79921;
          border-radius: 5px;
          margin-bottom: 2px;
      }

      /*
      #pulseaudio.muted {
          background-color: #90b1b1;
          color: #2a5c45;
      }
      */

      #wireplumber {
          background-color: #fff0f5;
          color: #000000;
      }

      #wireplumber.muted {
          background-color: #f53c3c;
      }

      #custom-media {
          background-color: #66cc99;
          color: #2a5c45;
          min-width: 100px;
      }

      #custom-media.custom-spotify {
          background-color: #66cc99;
      }

      #custom-media.custom-vlc {
          background-color: #ffa000;
      }

      #temperature {
          background-color: #f0932b;
      }

      #temperature.critical {
          background-color: #eb4d4b;
      }

      #tray {
          background-color: #ec7024;
          color: #282828;
          font-family: JetBrainsMono Nerd Font, monospace;
          font-size: 15px;
          font-weight: bold;
          border: none;
          border-bottom: 8px solid #d05806;
          border-radius: 5px;
          margin-bottom: 2px;
      }

      #tray > .passive {
          -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: #eb4d4b;
      }

      #idle_inhibitor {
          background-color: #2d3436;
      }

      #idle_inhibitor.activated {
          background-color: #ecf0f1;
          color: #2d3436;
      }

      #mpd {
          background-color: #66cc99;
          color: #2a5c45;
      }

      #mpd.disconnected {
          background-color: #f53c3c;
      }

      #mpd.stopped {
          background-color: #90b1b1;
      }

      #mpd.paused {
          background-color: #51a37a;
      }

      #language {
          background: #00b093;
          color: #740864;
          padding: 0 5px;
          margin: 0 5px;
          min-width: 16px;
      }

      #keyboard-state {
          background: #97e1ad;
          color: #000000;
          padding: 0 0px;
          margin: 0 5px;
          min-width: 16px;
      }

      #keyboard-state > label {
          padding: 0 5px;
      }

      #keyboard-state > label.locked {
          background: rgba(0, 0, 0, 0.2);
      }

      #scratchpad {
          background: rgba(0, 0, 0, 0.2);
      }

      #scratchpad.empty {
      	background-color: transparent;
      }

      tooltip {
        background-color: #1f2223;
        border: none;
        border-bottom: 8px solid #191c1d;
        border-radius: 5px;
      }

      tooltip decoration {
        box-shadow: none;
      }

      tooltip decoration:backdrop {
        box-shadow: none;
      }

      tooltip label {
        color: #ebdbb2;
        font-family: JetBrainsMono Nerd Font, monospace;
        font-size: 16px;
        padding-left: 5px;
        padding-right: 5px;
        padding-top: 0px;
        padding-bottom: 5px;
      }

    '';
  };
}
