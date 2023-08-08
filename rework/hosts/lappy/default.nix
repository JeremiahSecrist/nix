{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  # TODO decide what should be in defaults module
  environment.systemPackages = with pkgs; [
  ];
  stylix = {
    image = ../home-manager/sky/wallpapers/Darth-VaderSci-Fi-Star-Wars-4k-Ultra-HD-Wallpaper.jpg; # TODO new mapping
    polarity = "dark";
    targets = {
      gnome.enable = true;
      grub.enable = true;
      gtk.enable = true;
    };
  };
  zramSwap.enable = lib.mkDefault true;
  boot.kernel.sysctl = {"kernel.sysrq" = 1;};
  programs.noisetorch.enable = true;
  programs.zsh.enable = true;
  services.zerotierone = {
    enable = true;
    joinNetworks = [
      "12ac4a1e71a74f47"
    ];
  };
  custom = {
    # desktop.gnome.enable = true;
    desktop.hyprland.enable = true;
  };
  programs.steam.enable = true;
  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };
  base.defaults.region.enable = true;
  # Open ports in the firewall.
  networking = {
    networkmanager.enable = true;
    hostName = "lappy";
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
  };
  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    registry = {
      self.flake = inputs.self;
      nixpkgs.flake = inputs.nixpkgs;
    };
  };
  system.stateVersion = "22.11";
}
