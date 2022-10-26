{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-22.05-small";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self, nixpkgs, nixos-hardware, nixpkgs-small, home-manager, ... }@inputs:
    let system = "x86_64-linux";
    in {
      nixosModules = import ./modules/nixos inputs;
      nixosConfigurations = {
        laptop = import ./system/laptop (inputs // {
          inherit system nixos-hardware;
          inherit (nixpkgs) lib;
        });
        desksky = import ./system/desktop (inputs // {
          inherit system;
          inherit (nixpkgs) lib;
        });
        cacheServer = import ./system/cacheServer (inputs // {
          inherit system;
          inherit (nixpkgs-small) lib;
        });
        logiCacheServer = import ./system/logiCacheServer (inputs // {
          inherit system;
          inherit (nixpkgs-small) lib;
        });
      };
    };
}
