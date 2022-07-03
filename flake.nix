{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05-small";
        # nixpkgs-unstable.url = "nixpkgs/nixos-unstable"; 
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
                skytop = import ./system/laptop (inputs // { inherit lib system; });
                cache_server = import ./system/cache_server (inputs // { inherit lib system; });
            };
        };
}