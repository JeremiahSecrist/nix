{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
        home-manager = {
            url = github:nix-community/home-manager;
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    outputs = { self, nixpkgs, home-manager, ... }@inputs:
        let
            system = "x86_64-linux";
            pkgs = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
            };
            lib = nixpkgs.lib;
        in {
            nixosModules = import ./modules/nixos inputs;
            # homeModules  = import ./modules/hm inputs;
            nixosConfigurations = {
                skytop = lib.nixosSystem {
                    inherit system;
                    modules = [
                        ./system/laptop/configuration.nix
                        home-manager.nixosModules.home-manager {
                            home-manager.useGlobalPkgs = true;
                            home-manager.useUserPackages = true;
                            home-manager.users.sky = {
                                imports = [ ./hm/sky/home.nix ];
                            };
                        }
                    ]++ (with self.nixosModules; [
                        common
                        sound
                        yubikey
                        u2fLogin
                        gnomeDesktop
                    ]);
                };
            };
        };
}