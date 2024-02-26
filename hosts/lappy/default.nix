{
  self,
  inputs,
  config,
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

  systemd.services.bctl = {
    enable = (config.local.impermanence.enable);
    wantedBy = ["multi-user.target"];
    after = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.brightnessctl}/bin/brightnessctl set 10%'';
    };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  # boot.initrd.extraUtilsCommands = lib.mkIf (!config.boot.initrd.systemd.enable) ''
  #    copy_bin_and_libs
  #    cp -pv ${pkgs.glibc.out}/lib/libnss_files.so.* $out/lib
  #  '';
  # boot.initrd.postDeviceCommands = lib.mkAfter ''
  #   /bin/brightnessctl set 10%
  # '';
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
    inputs.agenix.packages.x86_64-linux.default
    age-plugin-yubikey
  ];
  boot.kernel.sysctl = {"kernel.sysrq" = 1;};

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Budgie Desktop environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.budgie.enable = true;
  programs.command-not-found.enable = false;
  programs.nix-index-database.comma.enable = true;
  services.tailscale.enable = true;
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
    yubikey.enable = true;
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
  programs = {
    ssh.extraConfig = ''
    # Don't ask for fingerprint confirmation on first connection.
    # If we know the fingerprint ahead of time, we should put it into `known_hosts` directly.
    StrictHostKeyChecking=accept-new
    '';
    zsh.enable = true;
    steam.enable = true;
    gamemode = {
      enable = true;
      enableRenice = true;
    };
  };
  networking = {
    # dhcpcd.enable = false;
    # nameservers = ["1.1.1.1" "1.0.0.1"];
    networkmanager = {
      enable = true;
      insertNameservers = ["1.1.1.1" "1.0.0.1"];
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
