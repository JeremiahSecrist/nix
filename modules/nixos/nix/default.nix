{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types optionalString;
  cfg = config.personal.nix;
in {
  options.personal.nix = {
    enable = mkEnableOption "";
    isBuilder = mkOption {
      default = false;
      type = types.bool;
    };
    allowUnfree = mkOption {
      default = true;
      type = types.bool;
    };
  };
  config = {
    nixpkgs.config = {
      allowUnfree = cfg.allowUnfree;
      contentAddressedByDefault = true;
    };
    nix = {
      sshServe.enable = cfg.isBuilder;
      package = pkgs.nixFlakes;

      extraOptions = ''
        experimental-features = nix-command flakes ca-derivations
      '';

      distributedBuilds = cfg.isBuilder;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      settings = {
        auto-optimise-store = true;
        keep-outputs = cfg.isBuilder;
        keep-derivations = cfg.isBuilder;
        trusted-public-keys = [
          "laptop-deploy:OMe69aOGxkvIhEYIECd1U3CE/PAouObowS7W4nDS460="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          # "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        ];
        builders-use-substitutes = true;
        substituters = [
          # "https://anyrun.cachix.org"
          "https://cache.nixos.org"
        ];

        secret-key-files = /var/lib/nix-keys/deploy.secret;
        allowed-users = [
          "@wheel"
          "@builders"
        ];
        trusted-users = [
          "root"
          "nix-ssh"
        ];
      };
    };
  };
}
