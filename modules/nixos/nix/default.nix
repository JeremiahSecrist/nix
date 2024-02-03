{
  inputs,
  self,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
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
    environment = {
      etc."current-config".source = inputs.self.outPath;
    };
    nixpkgs.config = {
      allowUnfree = cfg.allowUnfree;
      # contentAddressedByDefault = true;
    };
    nix = {
      sshServe.enable = cfg.isBuilder;
      package = pkgs.nixFlakes;

      extraOptions = ''
        experimental-features = nix-command flakes ca-derivations
      '';
      nixPath = ["nixpkgs=flake:nixpkgs"];
      registry.nixpkgs.flake = inputs.nixpkgs;
      distributedBuilds = cfg.isBuilder;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      settings = {
        flake-registry = builtins.toFile "empty-flake-registry.json" ''{"flakes":[],"version":2}'';
        auto-optimise-store = true;
        keep-outputs = cfg.isBuilder;
        keep-derivations = cfg.isBuilder;
        trusted-public-keys = [
          "laptop-deploy:OMe69aOGxkvIhEYIECd1U3CE/PAouObowS7W4nDS460="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
        ];
        builders-use-substitutes = true;
        substituters = [
          # "https://anyrun.cachix.org"
          "https://cache.nixos.org"
          "https://cache.ngi0.nixos.org"
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
