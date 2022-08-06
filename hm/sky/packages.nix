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
    tldr
    sshfs
    nixfmt
    cmatrix
    noisetorch
    # protonvpn-cli

    # Desktop
    rustdesk
    distrobox
    cryptomator
    firefox-wayland
    yubioath-desktop
    spotify
    discord
    gnupg
    virt-manager
    # development
    terraform

  ];
}
