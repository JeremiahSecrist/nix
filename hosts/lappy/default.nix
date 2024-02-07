{
  self,
  inputs,
  pkgs,
  lib,
  ...
}: {
  disko = import ../../modules/nixos/disks/impermanence.nix {
    device = "/dev/nvme0n1";
    swapSize = "8G";
  };
  hardware.opengl.extraPackages = [pkgs.vaapiVdpau];
  boot.loader.systemd-boot.enable = true;
  # programs.ssh.startAgent = false;
  # services.yubikey-agent.enable = true;
  # programs.gnupg.agent.enable = true;
  # hardware.gpgSmartcards.enable = true;

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

  local = {
    impermanence.enable = true;
    hardware = {
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
  services = {
    flatpak.enable = true;
    preload.enable = true;
  };
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
