{
  fetchurl,
  appimageTools,
  libsecret,
  hash ? "sha256-stHh+QKuZwni9OvB5FxRLEnBlr6tDQbUXWjEPGrWKaE=",
}:
appimageTools.wrapType2 rec {
  name = "tabby";
  version = "1.0.205";

  src = fetchurl {
    url = "https://github.com/Eugeny/tabby/releases/download/v${version}/tabby-${version}-linux-x64.AppImage";
    name = "${name}-${version}.AppImage";
    inherit hash;
  };

  extraPkgs = pkgs: with pkgs; [libsecret];

  extraInstallCommands = let
    appimageContents = appimageTools.extractType2 {inherit name version src;};
  in ''
     install -m 444 -D ${appimageContents}/tabby.desktop $out/share/applications/tabby.desktop
     install -m 444 -d ${appimageContents}/share/icons/hicolor/* $out/share/icons/hicolor
     substituteInPlace $out/share/applications/tabby.desktop \
    --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${name} %U'
  '';
}
