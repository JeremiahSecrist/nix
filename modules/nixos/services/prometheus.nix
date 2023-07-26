{
  config,
  pkgs,
  ...
}: {
  services.prometheus = {
    enable = true;
    port = 9001;
    # Export the current system metrics
    exporters = {
      node = {
        enable = true;
        enabledCollectors = ["systemd"];
        port = 9002;
      };
    };
    scrapeConfigs = [
      # Scrape the current system
      {
        job_name = "GrafanaService system";
        static_configs = [
          {
            targets = ["127.0.0.1:9002"];
          }
        ];
      }
      # Scrape the Loki service
      {
        job_name = "Loki service";
        static_configs = [
          {
            targets = ["127.0.0.1:3100"];
          }
        ];
      }
    ];
  };
}
