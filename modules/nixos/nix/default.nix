{
  inputs,
  self,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.local.nix;
in {
  options.local.nix = {
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
      distributedBuilds = true;
      sshServe.enable = cfg.isBuilder;
      package = pkgs.nixFlakes;

      extraOptions = ''
        experimental-features = nix-command flakes ca-derivations
      '';
      nixPath = ["nixpkgs=flake:nixpkgs"];
      registry.nixpkgs.flake = inputs.nixpkgs;
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
          "arouzing.win:+4szwdPI0O7IquMOYB7dSG8KwpTcMBB1txnf/ujAmLg="
          # "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        ];
        builders-use-substitutes = true;
        substituters = [
          # "https://cache.nixos.org?priority=1"
          # "https://cache.arouzing.win/"
          # "ssh-ng://nix-ssh@arouzing.win?priority=100&want-mass-query=true"
        ];

        # secret-key-files = /var/lib/nix-keys/deploy.secret;
        allowed-users = [
          "@wheel"
          "@builders"
        ];
          trusted-users = [
          "root"
          "nix-ssh"
        ];
      };
      buildMachines = [
          {
            hostName = "arouzing.win";
            protocol = "ssh-ng";
            maxJobs = 8;
            systems = [
              "x86_64-linux"
              "i686-linux"
            ];
            supportedFeatures = [
              "big-parallel"
              "nixos-test"
              "kvm"
              "benchmark"
            ];
            sshUser = "builder";
            sshKey = "/root/.ssh/id_ed25519";
            # publicHostKey = config.local.keys.gerg-desktop_fingerprint;
          }
        ];
    };
  };
}
