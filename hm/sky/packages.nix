{ config, pkgs, lib, ... }: {
  home.packages = with pkgs; [
    # desktop look & feel
    gnome.gnome-tweaks # desktop settings
    # extensions
    gnomeExtensions.appindicator
    # CLI
    (pkgs.uutils-coreutils.override { prefix = ""; })
    btop
    dconf2nix
    nano
    git
    gnupg
    tldr
    sshfs
    nixfmt
    cmatrix
    noisetorch
    # protonvpn-cli
    cpu-x
    sl
    lolcat
    # Desktop
    tor-browser-bundle-bin
    firmware-manager
    lutris
    distrobox
    cryptomator
    firefox
    brave
    yubioath-desktop
    spotify
    discord
    armcord
    virt-manager
    protonvpn-gui
    protonvpn-cli
    #work
    teams
  ];
}
