{pkgs}: let
  inherit (pkgs) pavucontrol swaynotificationcenter coreutils-full;
in {
  height = 35;
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
    layer = "bottom";
    format = " ";
    format-icons = {
      dnd-inhibited-none = "";
      dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
      dnd-none = "";
      dnd-notification = "<span foreground='red'><sup></sup></span>";
      inhibited-none = "";
      inhibited-notification = "<span foreground='red'><sup></sup></span>";
      none = "";
      notification = "<span foreground='red'><sup></sup></span>";
    };
    return-type = "json";
    # exec-if = "which swaync-client";
    # exec = "swaync-client -swb";
    on-click = "${coreutils-full}/bin/sleep 0.2; ${swaynotificationcenter}/bin/swaync-client -t -sw";
    # on-click-right = "swaync-client -d -sw";
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
    format = "{name}";
    # format-icons = {
    #   # "1" = "";
    #   # "2" = "";
    #   # "3" = "";
    #   # "4" = "";
    #   # "5" = "";
    #   active = "";
    #   default = "";
    # };
    sort-by-number = true;
  };
  battery = {
    states = {
      good = 95;
      warning = 30;
      critical = 15;
    };
    format = "{capacity}% {icon} ";
    format-alt = "{time} {icon} ";
    format-charging = "{capacity}%  ";
    format-icons = ["" "" "" "" ""];
    format-plugged = "{capacity}%  ";
    format-time = "{H}:{M}";
  };
  network = {
    format-alt = "{ifname}: {ipaddr}/{cidr}";
    format-disconnected = "Disconnected ⚠";
    format-ethernet = "Ethernet ";
    format-linked = "{ifname} (No IP)";
    format-wifi = "{essid} ({signalStrength}%) ";
    tooltip-format = "{ifname} via {gwaddr}";
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
    on-click = "${pavucontrol}/bin/pavucontrol";
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
}
