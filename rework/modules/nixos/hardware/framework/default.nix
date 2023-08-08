{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];
  boot = {
    kernelPackages = pkgs.linuxPackages_linux_lqx;
    initrd = {
      kernelModules = [
        "dm-snapshot"
      ];
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "uas"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
    };
    kernelModules = [
      "kvm-intel"
    ];
    supportedFilesystems = ["ntfs"];
    extraModulePackages = with config.boot.kernelPackages; [];
    kernelParams = [];
    kernelPatches = [];
  };
  services = {
    # this devices supports firmware updates
    fwupd.enable = true;
    # uses i915 driver
    xserver.videoDriver = "i915";
    # enable proper mouse usage on xorg.
    xserver.libinput.enable = true;
    # ssd only device
    fstrim.enable = true;
  };
  hardware = {
    enableAllFirmware = true; # why worry about it?
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    # laptop supports bt
    bluetooth.enable = true;
  };
  # dynamic dhcp
  networking.useDHCP = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = "powersave";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
