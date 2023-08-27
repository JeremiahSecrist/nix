{
  height = 35;
  spacing = 4;
  layer = "top";
  modules-left = ["wlr/workspaces"];
  modules-center = ["hyprland/window"];
  modules-right = ["custom/notification" "pulseaudio" "cpu" "temperature" "battery" "clock" "tray"];
  clock = {
    timezone = "America/New_York";
    tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    format = "{:%a, %d %b, %I:%M %p}";
  };
  "custom/notification" = {
    tooltip = false;
    format = "{icon}";
    format-icons = {
      notification = "<span foreground='red'><sup></sup></span>";
      none = "";
      dnd-notification = "<span foreground='red'><sup></sup></span>";
      dnd-none = "";
      inhibited-notification = "<span foreground='red'><sup></sup></span>";
      inhibited-none = "";
      dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
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
    max-length = 200;
    separate-outputs = true;
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
    format = "{capacity}% {icon}";
    format-charging = "{capacity}% ";
    format-plugged = "{capacity}% ";
    format-alt = "{time} {icon}";
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
    format = "{volume}% {icon} {format_source}";
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
    format = "{usage}% ";
    tooltip = false;
  };
  memory = {
    format = "{}% ";
  };
  temperature = {
    format = "{temperatureC}°C {icon}";
    format-icons = [""];
  };
}
