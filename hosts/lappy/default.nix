{
  self,
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  # nixpkgs.overlays = [
  #   (self: super: {
  #     bambu-studio = inputs.bambu-studio.legacyPackages.x86_64-linux.bambu-studio;
  #   })
  # ];
  # nixpkgs.config.permittedInsecurePackages = [
  #   "openssl-1.1.1u"
  # ];
  hardware.opengl.extraPackages = [ pkgs.vaapiVdpau ];
  services.pcscd.enable = true;
  services.pcscd.plugins = [
    pkgs.ccid
    pkgs.pcsclite
  ];
  services.udev.packages = [
      pkgs.yubikey-personalization
      pkgs.libu2f-host
    ];
    services.yubikey-agent.enable = true;
  environment.sessionVariables = {
    # NIXOS_SPECIALIZATION = lib.mkDefault "default";
  };
  # specialisation = {
  # gnome.configuration = {
  # environment.sessionVariables = {
  #   # MESA_VK_DEVICE_SELECT_FORCE_DEFAULT_DEVICE = "1";
  #   # MESA_VK_WSI_PRESENT_MODE = "immediate";
  #   KWIN_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
  #   RADV_PERFTEST = "nosam"; #performance improvement for eGPUs
  # };
  # personal.desktop.hyprland.enable = lib.mkForce false;
#  services.udev.extraRules = ''
#     SUBSYSTEM=="drm", KERNEL=="card[0-9]", TAG-="seat", TAG-="master-of-seat", ENV{ID_FOR_SEAT}="", ENV{ID_PATH}=""
    #  SUBSYSTEM=="drm", KERNEL=="card[0-9]", TAG-="mutter-device-preferred-primary"
#     SUBSYSTEM=="drm", KERNEL=="card1", TAG+="seat", TAG+="master-of-seat"
#  '';
  #  ENV{DEVNAME}=="/dev/dri/card0", TAG="dummytag"
  services.gnome.tracker-miners.enable = false;
  services.gnome.tracker.enable = false;
  # personal.desktop.displayManager.tuigreet.enable = true;
  # };
  # };
  # networking.stevenblack.enable = true;
  # services.switcherooControl.enable = true;
  virtualisation.vmVariant = {
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;
    environment.sessionVariables = {
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
  system.nixos.tags = [
    "${toString self.rev or self.dirtyRev}"
  ];
  # TODO decide what should be in defaults module
  # environment.systemPackages = with pkgs; [
  # ];
  # stylix = {
  #   image = ../home-manager/sky/wallpapers/Darth-VaderSci-Fi-Star-Wars-4k-Ultra-HD-Wallpaper.jpg; # TODO new mapping
  #   polarity = "dark";
  #   targets = {
  #     gnome.enable = true;
  #     grub.enable = true;
  #     gtk.enable = true;
  #   };
  # };
  # security.apparmor.enable = true;
  # security.apparmor.packages = [pkgs.apparmor-profiles];

  zramSwap.enable = lib.mkDefault true;
  services.teamviewer.enable = true;
  # virtualisation.libvirtd.enable = true;
  environment.systemPackages = with pkgs; [
    # virt-manager
    # (callPackage ../../packages/parsec {})
    parsec-bin
  ];
  # virtualisation.podman = {
    # enable = true;
  # };
  boot.kernel.sysctl = {"kernel.sysrq" = 1;};
  programs.noisetorch.enable = true;
  programs.zsh.enable = true;
  # services.zerotierone = {
    # enable = true;
    # joinNetworks = [
      # "12ac4a1e71a74f47"
    # ];
  # };
  # hardware.wooting.enable = true;
  services.xserver.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager = {
    gdm = {
      enable = true;
      wayland = true;
    };
    defaultSession = "plasmawayland";
  };

  personal = {
    hardware = {
      disks.encryptedBoot.enable = true;
      framework.enable = true;
      sound.enable = true;
    };
    # desktop.gnome.enable = true;
    # desktop.gnome.enable = true;
    region.enable = true;
    desktop = {
      # hyprland.enable = true;
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
  services.flatpak.enable = true;
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
      checkReversePath = false;
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
