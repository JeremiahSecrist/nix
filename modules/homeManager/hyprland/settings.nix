{config, ...}: let
  pointer = config.home.pointerCursor;
in {
  env = [
    "WLR_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0"
    "XCURSOR_SIZE,${toString pointer.size}"
    "GDK_SCALE,1.75"
  ];

  monitor = [
    "eDP-1,highres,auto,1.75"
    ",highrr,auto,auto"
  ];
  xwayland = {
    force_zero_scaling = true;
  };

  "$mainMod" = "SUPER";

  bind = [
    ",XF86MonBrightnessDown,exec,brightnessctl set 5%-"
    ",XF86MonBrightnessUp,exec,brightnessctl set +5%"
    "$mainMod, T, exec, kitty"
    "$mainMod, L, exec, swaylock"
    "$mainMod, S, exec, grimshot copy area"
    "$mainMod, Q, killactive,"
    "$mainMod, M, exit,"
    "$mainMod, E, exec, thunar"
    "$mainMod, V, togglefloating,"
    "$mainMod, R, exec, wofi --show drun -I -a -n -W 500 -H 376 -s --term kitty"
    "$mainMod, P, pseudo," # dwindle
    "$mainMod, J, togglesplit," # dwindle
    "$mainMod, F, fullscreen"
    "CTRL ALT, V, exec, sleep 1 && YDOTOOL_SOCKET=/run/user/1000/.ydotool_socket ydotool type -d 150 $(wl-paste)"
    "$mainMod, left, movefocus, l"
    "$mainMod, right, movefocus, r"
    "$mainMod, up, movefocus, u"
    "$mainMod, down, movefocus, d"
    "$mainMod, 1, workspace, 1"
    "$mainMod, 2, workspace, 2"
    "$mainMod, 3, workspace, 3"
    "$mainMod, 4, workspace, 4"
    "$mainMod, 5, workspace, 5"
    "$mainMod, 6, workspace, 6"
    "$mainMod, 7, workspace, 7"
    "$mainMod, 8, workspace, 8"
    "$mainMod, 9, workspace, 9"
    "$mainMod, 0, workspace, 10"
    "$mainMod SHIFT, 1, movetoworkspace, 1"
    "$mainMod SHIFT, 2, movetoworkspace, 2"
    "$mainMod SHIFT, 3, movetoworkspace, 3"
    "$mainMod SHIFT, 4, movetoworkspace, 4"
    "$mainMod SHIFT, 5, movetoworkspace, 5"
    "$mainMod SHIFT, 6, movetoworkspace, 6"
    "$mainMod SHIFT, 7, movetoworkspace, 7"
    "$mainMod SHIFT, 8, movetoworkspace, 8"
    "$mainMod SHIFT, 9, movetoworkspace, 9"
    "$mainMod SHIFT, 0, movetoworkspace, 10"
    "$mainMod ALT, left, workspace, e-1"
    "$mainMod ALT, right, workspace, e+1"
  ];
  binde = [
    ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"
    ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"
    "$mainMod SHIFT,right,resizeactive,50 0"
    "$mainMod SHIFT,left,resizeactive,-50 0"
    "$mainMod SHIFT,up,resizeactive,0 -50"
    "$mainMod SHIFT,down,resizeactive,0 50"
  ];
  bindl = [
    # ",switch:off:Lid Switch, exec,hyprctl keyword monitor \"eDP-1, highres, auto, 1.75\""
    # ",switch:on:Lid Switch, exec,hyprctl keyword monitor \"eDP-1, disable\""
    ",switch:off:Lid Switch, exec,swaylock"
  ];
  bindm = [
    "$mainMod, mouse:272, movewindow"
    "$mainMod, mouse:273, resizewindow"
  ];
  windowrulev2 = [
    "fakefullscreen, class:^(code-url-handler)$"
    "move cursor 0 10, class:^(waybar)$, floating:1"
    "size 700 500,title:^(.*(Open|Save) File.*)$,center"
  ];

  exec-once = [
    # "waybar"
    # "swaync"
    "hyprctl setcursor ${pointer.name} ${toString pointer.size}"
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    "swaybg -i $HOME/Pictures/wallpapers/Darth-VaderSci-Fi-Star-Wars-4k-Ultra-HD-Wallpaper.jpg"
    "sleep 1 && systemctl --user restart waybar.service"
  ];

  # Some default env vars.
  # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
  input = {
    kb_layout = "us";
    kb_variant = "";
    kb_model = "";
    kb_options = "";
    kb_rules = "";
    follow_mouse = 1;
    touchpad = {
      disable_while_typing = false;
      #clickfinger_behavior = true
      tap-to-click = true;
      natural_scroll = true;
      scroll_factor = 0.5;
    };

    sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
  };
  general = {
    gaps_in = 2;
    gaps_out = 10;
    border_size = 1;
    "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
    "col.inactive_border" = "rgba(595959aa)";
    layout = "dwindle";
  };
  decoration = {
    rounding = 5;
    drop_shadow = true;
    shadow_range = 4;
    shadow_render_power = 3;
    "col.shadow" = "rgba(1a1a1aee)";
    blur = {
      size = 2;
      passes = 1;
      new_optimizations = true;
    };
  };
  animations = {
    enabled = true;
    bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

    animation = [
      "windows, 1, 7, myBezier"
      "windowsOut, 1, 7, default, popin 80%"
      "border, 1, 10, default"
      "borderangle, 1, 8, default"
      "fade, 1, 7, default"
      "workspaces, 1, 6, default"
    ];
  };
  dwindle = {
    pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = true; # you probably want this
  };
  master = {
    new_is_master = true;
  };
  gestures = {
    workspace_swipe = true;
    workspace_swipe_distance = 100;
  };
  "device:epic-mouse-v1" = {
    sensitivity = "-0.5";
  };
  misc = {
    vfr = false;
    disable_hyprland_logo = true;
    vrr = 2;
  };
}
