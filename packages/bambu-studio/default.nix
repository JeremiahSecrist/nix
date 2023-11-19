{
  lib,
  pkgs,
  ...
}: let
  name = "bambu-studio";
  src = pkgs.fetchurl {
    url = "https://github.com/bambulab/BambuStudio/releases/download/v01.07.04.52/Bambu_Studio_linux_fedora-v01.07.04.52.AppImage";
    hash = "sha256-UM1hfy2qsQX0oVXtscqRHKdwO4aYsnavOfT7SvefW2s=";
  };
  desktopItem = pkgs.makeDesktopItem {
    inherit name;
    exec = name;
    icon = "BambuStudio";
    comment = "Software for Bambu Lab 3D printers";
    desktopName = "Bambu Studio";
    categories = ["Development"];
  };
  appimageContents = pkgs.appimageTools.extractType2 {inherit name src;};
in
  pkgs.appimageTools.wrapType2 {
    inherit name src;

    profile = ''
      export GIO_MODULE_DIR=${pkgs.glib-networking}/lib/gio/modules/
    '';

    extraPkgs = p:
      (pkgs.appimageTools.defaultFhsEnvArgs.multiPkgs p)
      ++ (with p; [
        gst_all_1.gst-plugins-bad
        libsoup
        mesa_drivers.osmesa
        webkitgtk
        zstd
        pkg-config
      ]);

    extraInstallCommands = ''
      mkdir -p $out/share/pixmaps
      ln -s ${desktopItem}/share/applications $out/share/
      cp ${appimageContents}/usr/share/icons/hicolor/192x192/apps/BambuStudio.png $out/share/pixmaps/BambuStudio.png
    '';

    meta = with lib; {
      homepage = "https://github.com/bambulab/BambuStudio/";
      description = "Software for Bambu Lab 3D printers";
      license = licenses.agpl3;
      platforms = ["x86_64-linux"];
    };
  }
