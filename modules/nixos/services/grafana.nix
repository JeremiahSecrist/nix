{
  pkgs,
  config,
  ...
}: {
  services = {
    grafana = {
      enable = true;
      settings.server = {
        enable_gzip = true;
        # http_addr = "127.0.0.1";
        # http_port = 3000;
        # rootUrl = "http://localhost:3000";
      };

      provision.datasources.settings.datasources = [
        # {
        #   name = "Prometheus";
        #   type = "prometheus";
        #   access = "proxy";
        #   url = "http://localhost:9001";
        #   isDefault = true;
        # }
        {
          name = "Loki";
          type = "loki";
          access = "proxy";
          url = "http://localhost:3100";
          isDefault = true;
        }
      ];
    };
  };
}
