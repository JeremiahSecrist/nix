{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
        nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-22.05-small";
        # nixpkgs-unstable.url = "nixpkgs/nixos-unstable"; 
        home-manager = {
            url = github:nix-community/home-manager;
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    outputs = { self, nixpkgs, nixpkgs-small, home-manager, ... }@inputs:
        let
            system = "x86_64-linux";
        in {
            nixosModules = import ./modules/nixos inputs;
            nixosConfigurations = {
                skytop      = import ./system/laptop             (inputs // { inherit system; inherit (nixpkgs)lib; });
                cacheServer = import ./system/cacheServer   (inputs // { inherit system; inherit (nixpkgs-small)lib; });
            };
        };
}