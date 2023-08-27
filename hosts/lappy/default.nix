{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      });
    })
  ];
  services.switcherooControl.enable = true;
  virtualisation.vmVariant = {
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;
    environment.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
    };
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 2048; # Use 2048MiB memory.
      cores = 8;
      qemu.options = [
        "-device virtio-vga-gl"
        "-display sdl,gl=on,show-cursor=off"
        "-audio pa,model=hda"
      ];
    };
  };

  # TODO decide what should be in defaults module
  environment.systemPackages = with pkgs; [
  ];
  # stylix = {
  #   image = ../home-manager/sky/wallpapers/Darth-VaderSci-Fi-Star-Wars-4k-Ultra-HD-Wallpaper.jpg; # TODO new mapping
  #   polarity = "dark";
  #   targets = {
  #     gnome.enable = true;
  #     grub.enable = true;
  #     gtk.enable = true;
  #   };
  # };

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
  hardware.wooting.enable = true;
  personal = {
    hardware = {
      disks.encryptedBoot.enable = true;
      framework.enable = true;
      sound.enable = true;
    };
    # desktop.gnome.enable = true;
    region.enable = true;
    desktop = {
      hyprland.enable = true;
    };
    nix = {
      enable = true;
      isBuilder = false;
      allowUnfree = true;
    };
    users.sky = {
      enable = true;
      password = "changeme";
    };
  };
  programs.steam.enable = true;
  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };
  # Open ports in the firewall.
  networking = {
    nameservers = ["1.1.1.1" "1.0.0.1"];
    networkmanager = {
      enable = true;
      insertNameservers = ["1.1.1.1" "1.0.0.1"];
    };
    hostName = "lappy";
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
  };
  nix = {
    registry = {
      self.flake = inputs.self;
      nixpkgs.flake = inputs.nixpkgs;
    };
  };
  system.stateVersion = "22.11";
}
