{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    disko.url = "github:nix-community/disko";
    devenv.url = "github:cachix/devenv/latest";
    nix-software-center.url = "github:vlinkz/nix-software-center";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, self, nixos-hardware, disko, home-manager, devenv
    , nix-software-center, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        framework-laptop =
          import ./hosts/framework-laptop { inherit system inputs; };
      };
      devShells.${system}.default = import ./shell.nix { inherit pkgs; };
      packages.${system} = {
        nixInstaller = pkgs.writeScriptBin "nixInstaller" ./scripts/install.sh;
        dcnixd = pkgs.writeScriptBin "dcnixd" ''
          dconf dump / | dconf2nix > dconf.nix
        '';
        editor = pkgs.writeScriptBin "editor" ''
          #!/usr/bin/env zsh
          zellij -l ./default.nix
        '';
        };
    };
}
