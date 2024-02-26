{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.yubikey;
in {
  options.local.yubikey = {
    enable = lib.mkEnableOption "enables yubikey settings";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pcscliteWithPolkit.out
    ];
    services.pcscd = {
      enable = true;
      plugins = with pkgs; [libykneomgr ccid];
    };
    programs.gnupg.agent = {
      enable = true;
      # enableSSHSupport = true;
    };

    services.udev.packages = [
      pkgs.yubikey-personalization
    ];
  };
}
