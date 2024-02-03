{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.personal.hardware.disks.encryptedBoot;
in {
  options.personal.hardware.disks.encryptedBoot.enable = mkEnableOption "";
  config = mkIf cfg.enable {
    boot.plymouth.enable = true;
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 2;
    };
    boot.initrd.luks.devices = {
      crypted = {
        # device = "/dev/sda3";
        preLVM = true;
        allowDiscards = true;
      };
    };
  };
}
