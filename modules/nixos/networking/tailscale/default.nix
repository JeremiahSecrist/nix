{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.local.networking.tailscale;
in {
  options.local.networking.tailscale.enable = mkEnableOption "";
  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "both";
    };
  };
}
