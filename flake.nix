{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    disko.url = "github:nix-community/disko";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self, nixpkgs, nixos-hardware, disko, home-manager, ... }@inputs:
    let system = "x86_64-linux";
    in {
      nixosConfigurations = {
        framework-laptop = import ./hosts/framework-laptop {
          inherit self system nixos-hardware home-manager disko;
          inherit (nixpkgs) lib;
        };
      };
    };
}
