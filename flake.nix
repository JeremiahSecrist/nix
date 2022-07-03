{
    inputs = {
        nixpkgs.url = "nixpkgs/nixos-22.05";
        unstable.url = "nixpkgs/nixos-unstable"; 
        home-manager = {
            url = github:nix-community/home-manager;
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    outputs = { self, nixpkgs, unstable, home-manager, ... }@inputs:
        let
            system = "x86_64-linux";
            overlay = { 
                pkg-sets = (
                    final: prev: {
                        unstable = import inputs.unstable { system = final.system; };
                        # trunk = import inputs.trunk { system = final.system; };
                    }
                );
            };
            # Overlays-module makes "pkgs.unstable" available in configuration.nix
            overlayModule = ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay ]; });
            pkgs = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
            };
            lib = nixpkgs.lib;
        in {
            nixosModules = import ./modules/nixos inputs;
            # homeModules  = import ./modules/hm inputs;
            nixosConfigurations = {
                skytop = import ./system/laptop (inputs // { inherit lib system; });
                cache_server = import ./system/cache_server (inputs // { inherit lib system; });
            };
        };
}