{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";

    };
    outputs = { self, nixpkgs }:
        let
            system = "x86_64-linux";
            pkgs = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
            };
            lib = nixpkgs.lib;
        in {
            nixosConfigurations = {
                skytop = lib.nixosSystem {
                    inherit system;
                    modules = [
                        ./system/laptop/configuration.nix
                    ];
                };
            };
        };
}