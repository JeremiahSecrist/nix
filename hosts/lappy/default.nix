{
  self,
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    (import ../../modules/nixos/disks/impermanence.nix {
      device = "/dev/nvme0n1";
      swapSize = "8G";
    })
  ];
  services.gnome.gnome-keyring.enable = false;
  # hardware.opengl.extraPackages = [pkgs.vaapiVdpau];
  # programs.ssh.startAgent = false;
  # services.yubikey-agent.enable = true;
  # programs.gnupg.agent.enable = true;
  # hardware.gpgSmartcards.enable = true;
  # security = { pkcs11Providers = [ "${pkgs.opensc}/lib/opensc-pkcs11.so" ]; };
  system.nixos.tags = ["${toString self.rev or self.dirtyRev or ""}"];

  zramSwap.enable = lib.mkDefault true;
  services.teamviewer.enable = true;

  environment.systemPackages = with pkgs; [
    parsec-bin
  ];
  boot.kernel.sysctl = {"kernel.sysrq" = 1;};
  # programs.noisetorch.enable = true;
  programs.zsh.enable = true;
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Budgie Desktop environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.budgie.enable = true;
  programs.command-not-found.enable = false;
  programs.nix-index-database.comma.enable = true;
  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  hardware.enableAllFirmware = true;
  local = {
    tmp.enable = true;
    impermanence.enable = true;
    # yubikey.enable = true;
    hardware = {
      framework.enable = true;
      sound.enable = true;
    };
    region = {enable = true;};
    nix = {
      enable = true;
      isBuilder = false;
      allowUnfree = true;
    };
    users.sky = {
      enable = true;
      password = "changeme";
    };
    # users.test = {
    #   enable = true;
    #   password = "changeme";
    # };
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
    # dhcpcd.enable = false;
    # nameservers = ["1.1.1.1" "1.0.0.1"];
    networkmanager = {
      enable = true;
      # insertNameservers = ["1.1.1.1" "1.0.0.1"];
    };
    hostName = "lappy";
    firewall = {
      enable = true;
      # checkReversePath = false;
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

  system.stateVersion = "23.11";
}
