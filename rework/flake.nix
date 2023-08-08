{
  inputs =  {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devenv.url = "github:cachix/devenv/latest";
    stylix.url = "github:danth/stylix";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs:
    with inputs; let
      system = "x86_64-linux";
      specialArgs = {inherit inputs self;};
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      mkNixos = system: config:
        nixpkgs.lib.nixosSystem {
          inherit specialArgs system;
          modules = [
            # agenix.nixosModules.default
            # devenv.nixosModules.default
            disko.nixosModules.default
            hyprland.nixosModules.default
            stylix.nixosModules.stylix
            ./modules/nixos
            config
          ];
        };
      mkHome = config:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = specialArgs;
          modules = [
            ./modules/homeManager
            config
          ];
        };
    in {
      nixosConfigurations = {
        lappy = mkNixos system ./hosts/lappy;
      };
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs;[
          just
        ];

        shellHook = ''
        '';
      };
    };
}
