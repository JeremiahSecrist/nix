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
        type = types.nullOr types.attrs;
        default = null;
      };
      raw = mkOption {
        type = types.nullOr types.path;
      };
    };
    agent = {
      enable = mkEnableOption "enables narrowlink agent";
      settings = mkOption {
        type = types.attrs;
      };
    };
    client = {
      enable = mkEnableOption "enables narrowlink client";
      settings = mkOption {
        type = types.attrs;
      };
    };
  };
  config = mkMerge [
    # (mkIf cfg.gateway.enable
    #   || cfg.agent.enable
    #   || cfg.client.enable {
    #   })
    (mkIf cfg.gateway.enable {
      systemd.services.narrowlink-gateway = {
        description = "gateway service for narrowlink";
        wantedBy = ["multi-user.target"];
        after = ["network.target"];
        serviceConfig = {
          DynamicUser = true;
          ExecStart = "${pkgs.narrowlink}/bin/narrowlink-gateway --config='${
            if cfg.gateway.settings != null
            then mkConfigFile cfg.gateway.settings
            else toString cfg.gateway.raw
          }'";
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
