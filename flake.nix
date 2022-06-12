{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
        home-manager = {
            url = github:nix-community/home-manager;
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    outputs = { self, nixpkgs, home-manager, ... }:
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
                        homa-manager.nixosModules.home-manager {
                            home-manager.useGlobalPkgs = true;
                            home-manager.useUserPackages = true;
                            home-manager.users.sky = {
                                import = [ ./hm/sky/home.nix]
                            };
                        };
                    ];
                };
            };
        };
}