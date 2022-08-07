{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-22.05-small";
    # nixpkgs-unstable.url = "nixpkgs/nixos-unstable"; 
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}