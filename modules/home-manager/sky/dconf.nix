# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, config, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "apps/seahorse/listing" = {
      keyrings-selected = [ "secret-service:///org/freedesktop/secrets/collection/login" ];
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file://${ config.home.homeDirectory }/Pictures/wallpapers/frameworkoptix.jpg";
      picture-uri-dark = "file://${ config.home.homeDirectory }/Pictures/wallpapers/frameworkoptix.jpg";
    };
    "apps/seahorse/windows/key-manager" = {
      height = 476;
      width = 600;
    };

    "com/github/akiraux/akira" = {
      left-paned = 377;
      pos-x = 0;
      pos-y = 0;
      recently-opened = [];
      right-paned = 1305;
      version = "0.0.16";
      window-height = 983;
      window-width = 1920;
    };

    "org/gnome/Console" = {
      font-scale = 1.2;
    };

    "org/gnome/calculator" = {
      accuracy = 9;
      angle-units = "degrees";
      base = 10;
      button-mode = "basic";
      number-format = "automatic";
      show-thousands = false;
      show-zeroes = false;
      source-currency = "";
      source-units = "degree";
      target-currency = "";
      target-units = "radian";
      word-size = 64;
    };

    "org/gnome/calendar" = {
      active-view = "month";
      window-maximized = true;
      window-size = mkTuple [ 768 600 ];
    };

    "org/gnome/control-center" = {
      last-panel = "display";
      window-state = mkTuple [ 980 640 ];
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = [ "Utilities" "YaST" ];
    };

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      apps = [ "gnome-abrt.desktop" "gnome-system-log.desktop" "nm-connection-editor.desktop" "org.gnome.baobab.desktop" "org.gnome.Connections.desktop" "org.gnome.DejaDup.desktop" "org.gnome.Dictionary.desktop" "org.gnome.DiskUtility.desktop" "org.gnome.eog.desktop" "org.gnome.Evince.desktop" "org.gnome.FileRoller.desktop" "org.gnome.fonts.desktop" "org.gnome.seahorse.Application.desktop" "org.gnome.tweaks.desktop" "org.gnome.Usage.desktop" "vinagre.desktop" ];
      categories = [ "X-GNOME-Utilities" ];
      name = "X-GNOME-Utilities.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/YaST" = {
      categories = [ "X-SuSE-YaST" ];
      name = "suse-yast.directory";
      translate = true;
    };

    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "us" ]) ];
      xkb-options = [ "terminate:ctrl_alt_bksp" ];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      gtk-theme = "Adwaita-dark";
    };

    "org/gnome/desktop/lockdown" = {
      disable-lock-screen = false;
    };

    "org/gnome/desktop/notifications" = {
      application-children = [ "org-gnome-console" "gnome-power-panel" "org-gnome-software" "code" "firefox" "discord" ];
    };

    "org/gnome/desktop/notifications/application/code" = {
      application-id = "code.desktop";
    };

    "org/gnome/desktop/notifications/application/discord" = {
      application-id = "discord.desktop";
    };

    "org/gnome/desktop/notifications/application/firefox" = {
      application-id = "firefox.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-power-panel" = {
      application-id = "gnome-power-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-console" = {
      application-id = "org.gnome.Console.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-nautilus" = {
      application-id = "org.gnome.Nautilus.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-settings" = {
      application-id = "org.gnome.Settings.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-software" = {
      application-id = "org.gnome.Software.desktop";
    };

    "org/gnome/desktop/notifications/application/org-mozilla-firefox" = {
      application-id = "org.mozilla.firefox.desktop";
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      numlock-state = true;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 0;
    };

    "org/gnome/desktop/sound" = {
      event-sounds = true;
      theme-name = "__custom";
    };

    "org/gnome/desktop/wm/keybindings" = {
      maximize = [ "<Super>Up" ];
    };

    "org/gnome/desktop/wm/preferences" = {
      workspace-names = [ "1" "2" ];
    };

    "org/gnome/eog/ui" = {
      sidebar = false;
    };

    "org/gnome/eog/view" = {
      background-color = "rgb(0,0,0)";
      use-background-color = true;
    };

    "org/gnome/evolution-data-server" = {
      migrated = true;
      network-monitor-gio-name = "";
    };

    "org/gnome/file-roller/dialogs/extract" = {
      recreate-folders = true;
      skip-newer = false;
    };

    "org/gnome/file-roller/listing" = {
      list-mode = "as-folder";
      name-column-width = 250;
      show-path = false;
      sort-method = "name";
      sort-type = "ascending";
    };

    "org/gnome/file-roller/ui" = {
      sidebar-width = 200;
      window-height = 480;
      window-width = 600;
    };

    "org/gnome/gnome-system-monitor" = {
      current-tab = "resources";
      maximized = false;
      network-total-in-bits = false;
      show-dependencies = false;
      show-whose-processes = "user";
      window-state = mkTuple [ 700 500 ];
    };

    "org/gnome/gnome-system-monitor/disktreenew" = {
      col-6-visible = true;
      col-6-width = 0;
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = true;
      dynamic-workspaces = true;
      edge-tiling = true;
      
      focus-change-on-pointer-rest = true;
      workspaces-only-on-primary = true;
    };

    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [ "<Super>Left" ];
      toggle-tiled-right = [ "<Super>Right" ];
    };

    "org/gnome/mutter/wayland/keybindings" = {
      restore-shortcuts = [ "" ];
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
      search-view = "list-view";
    };

    "org/gnome/nautilus/window-state" = {
      initial-size = mkTuple [ 890 550 ];
      maximized = true;
    };

    "org/gnome/nm-applet/eap/dc09bf41-0922-4e42-b923-f16f2b676dae" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/nm-applet/eap/f115300e-76a0-4c71-a91f-e64ddcd1a8a4" = {
      ignore-ca-cert = false;
      ignore-phase2-ca-cert = false;
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "suspend";
      sleep-inactive-ac-timeout = 3600;
    };

    "org/gnome/shell" = {
      app-picker-layout = "[{'org.gnome.Contacts.desktop': <{'position': <0>}>, 'org.gnome.Weather.desktop': <{'position': <1>}>, 'org.gnome.clocks.desktop': <{'position': <2>}>, 'org.gnome.Maps.desktop': <{'position': <3>}>, 'org.gnome.Calculator.desktop': <{'position': <4>}>, 'simple-scan.desktop': <{'position': <5>}>, 'org.gnome.Settings.desktop': <{'position': <6>}>, 'gnome-system-monitor.desktop': <{'position': <7>}>, 'Utilities': <{'position': <8>}>, 'yelp.desktop': <{'position': <9>}>, 'org.gnome.Calendar.desktop': <{'position': <10>}>, 'org.cryptomator.Cryptomator.desktop': <{'position': <11>}>, 'org.gnome.Extensions.desktop': <{'position': <12>}>, 'firefox.desktop': <{'position': <13>}>, 'cups.desktop': <{'position': <14>}>, 'nixos-manual.desktop': <{'position': <15>}>, 'org.gnome.Software.desktop': <{'position': <16>}>, 'spotify.desktop': <{'position': <17>}>, 'test-tabby.desktop': <{'position': <18>}>, 'org.gnome.TextEditor.desktop': <{'position': <19>}>, 'org.gnome.Tour.desktop': <{'position': <20>}>, 'xterm.desktop': <{'position': <21>}>, 'com.yubico.yubioath.desktop': <{'position': <22>}>}]";
      command-history = [ "pkill Discord" ];
      disable-user-extensions = true;
      disabled-extensions = [ "dash-to-dock@micxgx.gmail.com" "workspace-indicator@gnome-shell-extensions.gcampax.github.com" ];
      enabled-extensions = [ "appindicatorsupport@rgcjonas.gmail.com" "material-shell@papyelgringo" "auto-move-windows@gnome-shell-extensions.gcampax.github.com" "drive-menu@gnome-shell-extensions.gcampax.github.com" ];
      favorite-apps = [ "brave-browser.desktop" "org.gnome.Nautilus.desktop" "steam.desktop" "discord.desktop" "code.desktop" "org.gnome.Console.desktop" ];
      had-bluetooth-devices-setup = true;
      welcome-dialog-last-shown-version = "42.2";
    };

    "org/gnome/shell/extensions/auto-move-windows" = {
      application-list = [ "discord.desktop:1" "firefox.desktop:3" "code.desktop:2" "org.gnome.Console.desktop:2" ];
    };

    "org/gnome/shell/world-clocks" = {
      locations = "@av []";
    };

    "org/gnome/software" = {
      check-timestamp = mkInt64 1667257094;
      first-run = false;
    };

    "org/gnome/tweaks" = {
      show-extensions-notice = false;
    };

    "org/gtk/gtk4/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 169;
      sort-column = "name";
      sort-directories-first = false;
      sort-order = "ascending";
      type-format = "category";
      window-size = mkTuple [ 888 374 ];
    };

    "org/gtk/settings/file-chooser" = {
      date-format = "regular";
      location-mode = "path-bar";
      show-hidden = false;
      show-size-column = true;
      show-type-column = true;
      sidebar-width = 157;
      sort-column = "name";
      sort-directories-first = false;
      sort-order = "ascending";
      type-format = "category";
      window-position = mkTuple [ 26 23 ];
      window-size = mkTuple [ 1231 902 ];
    };

  };
}
