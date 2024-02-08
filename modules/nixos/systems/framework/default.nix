# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.local.hardware.framework;
  # test = lib.optionals config.local.hardware.framework.enable inputs.nixos-hardware.nixosModules.framework-12th-gen-intel;
in {
  imports = [
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  options.local.hardware.framework.enable = mkEnableOption "";
  config = mkIf cfg.enable {
    services = {
      power-profiles-daemon.enable = false;
      tlp = {
        enable = true;
        settings = {
          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        };
      };
      system76-scheduler.settings.cfsProfiles.enable = true;
      fwupd.enable = true;
      hardware.bolt.enable = true;
    };
    boot = {
      tmp.cleanOnBoot = true;
      # kernelPackages = pkgs.linuxPackages_lqx;
      kernel.sysctl = {
        "net.core.default_qdisc" = "fq";
        "net.ipv4.tcp_congestion_control" = "bbr";
      };
      kernelPackages = pkgs.linuxPackages_6_7;
      initrd = {
        kernelModules = [
          "dm-snapshot"
          "dm_mirror"
        ];
        availableKernelModules = [
          "nvme"
          "xhci_pci"
          "thunderbolt"
          "usbhid"
          "uas"
          "sd_mod"
        ];
      };
      kernelModules = [
        "kvm-amd"
      ];

      kernelParams = [
        "amd_iommu=on"
        "iommu=pt"
      ];
      # kernelPatches = [
      #   {
      #     name = "config";
      #     patch = null;
      #     extraConfig = ''
      #       KALLSYMS_ALL y
      #       FTRACE y
      #       KPROBES y
      #       PCI_QUIRKS y
      #       KALLSYMS y
      #       FUNCTION_TRACER y
      #     '';
      #   }
      # ];
    };
    # enable proper mouse usage on xorg.
    services.xserver.libinput.enable = true;
    hardware = {
      # laptop supports bt
      bluetooth.enable = true;
    };

    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # dynamic dhcp
    networking.useDHCP = lib.mkDefault true;
    # SSD optimization
    services.fstrim.enable = true;
    # networking.interfaces.eht0.useDHCP = lib.mkForce true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = true;
  };
}
