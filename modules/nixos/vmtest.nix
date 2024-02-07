{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.vmtests;
in {
  options.local.vmtests.enable = lib.mkEnableOption "enables vm settings";
  config = lib.mkIf cfg.enable {
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
  };
}
