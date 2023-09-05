{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkMerge mkIf mkEnableOption mkOption types;
  cfg = config.services.narrowlink;
  format = pkgs.formats.yaml {};
  mkConfigFile = x: format.generate "config.yaml" x;
in {
  options.services.narrowlink = {
    gateway = {
      enable = mkEnableOption "enables narrowlink gateway";
      settings = mkOption {
        types = types.attrset;
      };
    };
    agent = {
      enable = mkEnableOption "enables narrowlink agent";
      settings = mkOption {
        types = types.attrset;
      };
    };
    client = {
      enable = mkEnableOption "enables narrowlink client";
      settings = mkOption {
        types = types.attrset;
      };
    };
  };
  config = mkMerge [
    (mkIf cfg.gateway.enable
      || cfg.agent.enable
      || cfg.client.enable {
      })
    (mkIf cfg.gateway.enable {
      systemd.services.narrowlink-gateway = {
        description = "gateway service for narrowlink";
        wantedBy = ["multi-user.target"];
        after = ["network.target"];
        serviceConfig = {
          DynamicUser = true;
          ExecStart = "${pkgs.narrowlink}/bin/narrowlink-gateway --config ${mkConfigFile cfg.gateway.settings}";
          Restart = "on-failure";

          AmbientCapabilities = ["CAP_NET_BIND_SERVICE"];
          CapabilityBoundingSet = ["CAP_NET_BIND_SERVICE"];
        };
      };
    })
    (mkIf cfg.agent.enable {
      })
    (mkIf cfg.client.enable {
      })
  ];
}
