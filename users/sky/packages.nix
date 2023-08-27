{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # desktop look & feel
    # waybar
    webcord
    # gnome.gnome-tweaks # desktop settings
    # extensions
    # gnomeExtensions.appindicator
    # CLI
    nix-index
    comma
    #(pkgs.uutils-coreutils.override {prefix = "";})
    btop
    # dconf2nix
    # nano
    git
    gnupg
    tldr
    nixfmt
    # cmatrix
    # noisetorch
    # protonvpn-cli
    # cpu-x
    # sl
    # lolcat

    ## Desktop
    # tor-browser-bundle-bin
    # firmware-manager
    # lutris
    # distrobox
    # cryptomator
    # firefox
    yubioath-flutter
    # armcord
    # virt-manager
    protonvpn-gui
    protonvpn-cli
    #work
    # teams
  ];
}
