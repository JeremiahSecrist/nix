{ config, pkgs, lib, ... }: {
  home.packages = with pkgs; [
    # desktop look & feel
    gnome.gnome-tweaks # desktop settings
    # extensions
    gnomeExtensions.appindicator
    # CLI
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
    rustdesk
    distrobox
    cryptomator
    firefox
    brave
    yubioath-desktop
    spotify
    discord
    virt-manager

    #work
    teams
  ];
}
