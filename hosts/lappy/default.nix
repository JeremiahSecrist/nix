{
  self,
  inputs,
  pkgs,
  lib,
  ...
}: {
  hardware.opengl.extraPackages = [pkgs.vaapiVdpau];

  services.pcscd = {
    enable = true;
    plugins = with pkgs; [libykneomgr ccid];
  };
  # environment.sessionVariables.SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  services.udev.packages = [
    pkgs.yubikey-personalization
  ];
  # programs.ssh.startAgent = false;
  # services.yubikey-agent.enable = true;
  # programs.gnupg.agent.enable = true;
  # hardware.gpgSmartcards.enable = true;

  virtualisation.vmVariant = {
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      WLR_RENDERER_ALLOW_SOFTWARE = "1";
    };

    virtualisation = {
      memorySize = 2048;
      cores = 8;
      qemu.options = [
        "-device virtio-vga-gl"
        "-display sdl,gl=on,show-cursor=off"
        "-audio pa,model=hda"
      ];
    };
  };

  system.nixos.tags = ["${toString self.rev or self.dirtyRev}"];

  zramSwap.enable = lib.mkDefault true;
  services.teamviewer.enable = true;

  environment.systemPackages = with pkgs; [
    fwupd
    pcscliteWithPolkit.out
    parsec-bin
  ];

  boot.kernel.sysctl = {"kernel.sysrq" = 1;};
  programs.noisetorch.enable = true;
  programs.zsh.enable = true;

  services.xserver = {
    enable = true;
    desktopManager = {
      plasma5 = {enable = true;};
    };
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
      defaultSession = "plasmawayland";
    };
  };

  personal = {
    hardware = {
      disks.encryptedBoot.enable = true;
      framework.enable = true;
      sound.enable = true;
    };

    region = {enable = true;};

    desktop = {};

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
  # systemd.services.nix-daemon.environment.TMPDIR = "/var/tmp/nix-daemon";
  services.flatpak.enable = true;
  services.preload.enable = true;
  programs.steam.enable = true;
  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };

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
