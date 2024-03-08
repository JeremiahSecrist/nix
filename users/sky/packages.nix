{pkgs, ...}: {
  home.packages = with pkgs; [
    # nix-stable.nano
    # desktop look & feel
    # waybar
    # (callPackage ../../packages/bambu-studio {})
    # bambu-studio
    # (callPackage ../../packages/discord-krisp {})
    (callPackage ../../packages/tabby {})
    # webcord
    # ollama
    micro
    # nvim
    # openblas
    llama-cpp
    nil
    # stable
    # discord
    vesktop
    xdg-utils
    # appimage-run
    blender
    element-desktop
    # popsicle
    # gst_all_1.gstreamer
    mplayer
    # distrobox
    # bottles
    # parsec-bin
    warp
    # winetricks
    # wineWowPackages.fonts
    # wineWowPackages.stagingFull
    # zathura # pdf viewer
    # gnome.gnome-tweaks # desktop settings
    # extensions
    # gnomeExtensions.appindicator
    # CLI
    prismlauncher
    # nix-index
    # comma
    #(pkgs.uutils-coreutils.override {prefix = "";})
    btop
    # dconf2nix
    # nano
    git
    gnupg
    tldr
    nixfmt
    # nmap
    # cmatrix
    # noisetorch
    protonvpn-cli
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
    yubikey-personalization-gui
    yubioath-flutter
    # armcord
    # virt-manager
    protonvpn-gui
    # protonvpn-cli
    #work
    # teams
  ];
}
