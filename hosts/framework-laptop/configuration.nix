# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  services.yggdrasil = {
    enable = true;
    openMulticastPort = true;
    persistentKeys = true;
    settings = {
      "Peers" = [
        "tls://ygg.yt:443"
      ];
      "MulticastInterfaces" = [
        {
          "Regex" = "w.*";
          "Beacon" = true;
          "Listen" = true;
          "Port" = 9001;
          "Priority" = 0;
        }
      ];
      "AllowedPublicKeys" = [];
      "IfName" = "auto";
      "IfMTU" = 65535;
      "NodeInfoPrivacy" = false;
      "NodeInfo" = null;
    };
  };

  networking = {
    hostName = "lappy"; # Define your hostname.
  };
  programs.noisetorch.enable = true;
  services = {
    fwupd.enable = true;
  };
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
  # sound.enable = true;
  # services.xserver = {
  #   enable = true;
  #   layout = "us";
  #   xkbVariant = "";
  #   displayManager.sddm = {
  #     enable = true;
  #     # wayland = true;
  #   };
  # };
  services.fstrim.enable = true;
  # programs.steam.enable = true;
  # programs.gamemode = {
  #   enable = true;
  #   enableRenice = true;
  # };
  base.defaults.region.enable = true;
  hardware = {
    opengl.enable = true;
    opengl.driSupport = true;
    opengl.driSupport32Bit = true;
    steam-hardware.enable = true;
  };
  #   hardware.opengl.extraPackages = with pkgs; [
  #   rocm-opencl-icd
  #   rocm-opencl-runtime
  # ];
  hardware.enableAllFirmware = true;
  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [];
    allowedUDPPorts = [];
  };
  nix.registry.self.flake = inputs.self;
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  system.stateVersion = "22.11";
}
