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
  inherit (lib) mkEnableOption mkIf types;
  cfg = config.personal.hardware.framework;
  # test = lib.optionals config.personal.hardware.framework.enable inputs.nixos-hardware.nixosModules.framework-12th-gen-intel;
in {
  imports = [
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  options.personal.hardware.framework.enable = mkEnableOption "";
  config = mkIf cfg.enable {
    services.hardware.bolt.enable = true;
    disko = {
      checkScripts = true;
      devices = import ../disks/templates/lvm-luks.nix {
        disks = ["/dev/disk/by-id/usb-_USB_DISK_3.2_0700199604A32D02-0:0" "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S59ANMFNB34577E"];
        partitionSizes = ["34G" "220G" "700G"];
      };
    };
    boot = {
      tmp.cleanOnBoot = true;
      # kernelPackages = pkgs.linuxPackages_lqx;
      kernel.sysctl = {
        "net.core.default_qdisc" = "fq";
        "net.ipv4.tcp_congestion_control" = "bbr";
      };
      kernelPackages = pkgs.linuxPackages_testing;
      initrd = rec {
        kernelModules = availableKernelModules;
        availableKernelModules = [
          "amdgpu"
          "xhci_hcd"
          "xhci_pci"
          "usbhid"
          "thunderbolt"
          "nvme"
          "uas"
          "usb_storage"
          "dm-snapshot"
          "dm_mirror"
          "sd_mod"
        ];
      };
      kernelModules = [
        "kvm-amd"
      ];
      supportedFilesystems = [
        "bcachefs"
      ];
      # extraModulePackages = with config.boot.kernelPackages; [vendor-reset];
      kernelParams = [
        "amd_iommu=on"
        "iommu=pt"
        # "amdgpu.lockup_timeout=1000"
        # "amdgpu.gpu_recovery=1"
        # "amdgpu.noretry=0"
        # "amdgpu.reset_method=4"
        # "amdgpu.audio=0"
        # "amdgpu.si_support=1"
        # "radeon.si_support=0"
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
    nixpkgs.config.packageOverrides = pkgs: {
      # vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
    };
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      # extraPackages = with pkgs; [
      #   intel-media-driver # LIBVA_DRIVER_NAME=iHD
      #   vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      #   vaapiVdpau
      #   libvdpau-va-gl
      # ];
    };
    # dynamic dhcp
    networking.useDHCP = lib.mkDefault true;
    services.auto-cpufreq.enable = true;
    # SSD optimization
    services.fstrim.enable = true;
    # networking.interfaces.wlp166s0.useDHCP = lib.mkDefault true;
    powerManagement.cpuFreqGovernor = "powersave";
    #powerManagement.powertop.enable = true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
