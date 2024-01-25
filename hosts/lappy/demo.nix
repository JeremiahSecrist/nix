{
  pkgs,
  lib,
  ...
}:
pkgs.writeTextFile {
  name = "traefik-dashboard.yaml";
  text = lib.generators.toYAML {} {
    apiVersion = "helm.cattle.io/v1";
    kind = "HelmChartConfig";
    metadata = {
      name = "traefik";
      namespace = "kube-system";
    };
    spec = {
      valuesContent = {
        image = {
          name = "traefik";
          version = "2.10.7";
        };
        dashboard.enable = true;
        ports.traefik.expose = true;
        logs.access.enabled = true;
      };
    };
  };
}
