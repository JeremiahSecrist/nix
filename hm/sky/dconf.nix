# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "org/gnome/control-center" = {
      last-panel = "wifi";
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
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 300;
    };

    "org/gnome/evolution-data-server" = {
      migrated = true;
      network-monitor-gio-name = "";
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = true;
      dynamic-workspaces = true;
      edge-tiling = true;
      focus-change-on-pointer-rest = true;
      workspaces-only-on-primary = true;
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "suspend";
    };

    "org/gnome/shell" = {
      app-picker-layout = "[{'org.gnome.Geary.desktop': <{'position': <0>}>, 'org.gnome.Contacts.desktop': <{'position': <1>}>, 'org.gnome.Weather.desktop': <{'position': <2>}>, 'org.gnome.clocks.desktop': <{'position': <3>}>, 'org.gnome.Maps.desktop': <{'position': <4>}>, 'org.cryptomator.Cryptomator.desktop': <{'position': <5>}>, 'org.gnome.Photos.desktop': <{'position': <6>}>, 'org.gnome.Totem.desktop': <{'position': <7>}>, 'org.gnome.Calculator.desktop': <{'position': <8>}>, 'simple-scan.desktop': <{'position': <9>}>, 'org.gnome.Settings.desktop': <{'position': <10>}>, 'gnome-system-monitor.desktop': <{'position': <11>}>, 'org.gnome.Extensions.desktop': <{'position': <12>}>, 'Utilities': <{'position': <13>}>, 'cups.desktop': <{'position': <14>}>, 'yelp.desktop': <{'position': <15>}>, 'nixos-manual.desktop': <{'position': <16>}>, 'org.gnome.Cheese.desktop': <{'position': <17>}>, 'org.gnome.Software.desktop': <{'position': <18>}>, 'spotify.desktop': <{'position': <19>}>, 'org.gnome.TextEditor.desktop': <{'position': <20>}>, 'org.gnome.Tour.desktop': <{'position': <21>}>}, {'xterm.desktop': <{'position': <0>}>, 'com.yubico.yubioath.desktop': <{'position': <1>}>, 'org.gnome.Epiphany.desktop': <{'position': <2>}>, 'org.gnome.Calendar.desktop': <{'position': <3>}>, 'org.gnome.Music.desktop': <{'position': <4>}>, 'code.desktop': <{'position': <5>}>}]";
      favorite-apps = [ "firefox.desktop" "code.desktop" "discord.desktop" "org.gnome.Console.desktop" "org.gnome.Nautilus.desktop" ];
      welcome-dialog-last-shown-version = "42.2";
    };

    "org/gnome/shell/world-clocks" = {
      locations = "@av []";
    };

    "org/gnome/software" = {
      check-timestamp = mkInt64 1655076356;
      first-run = false;
    };

  };
}
