{
  config,
  pkgs,
  ...
}: {
  services.loki = {
    enable = true;
    configFile = ./loki.yaml;
  };
}
