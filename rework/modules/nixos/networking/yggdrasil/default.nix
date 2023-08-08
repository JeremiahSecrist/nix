{
    config,
    pkgs,
    lib,
    ...,
}: 
let
    inherit (lib) mkEnableOption mkIf mkDefault;
    cfg = config.personal.networking.yggdrasil;
in {
    options.personal.networking.yggdrasil = {
        enable = mkEnableOption "enables yggdrasil a sdwan solution";
    };
    config = mkIf cfg.enable {
        services.yggdrasil = mkDefault {
            enable = true;
            openMulticastPort = true;
            persistentKeys = true;
            settings = {
              Peers = [
                "tls://ygg.yt:443"
              ];
              MulticastInterfaces = [
                {
                  Regex = "w.*";
                  Beacon = true;
                  Listen = true;
                  Port = 9001;
                  Priority = 0;
                }
              ];
            AllowedPublicKeys = [];
            IfName = "auto";
            IfMTU = 65535;
            NodeInfoPrivacy = false;
            NodeInfo = null;
            };
        };
    };
}