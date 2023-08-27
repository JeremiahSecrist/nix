{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };
  outputs = inputs:
    with inputs; let
      system = "x86_64-linux";
      specialArgs = {inherit inputs self;};
      pkgs = import nixpkgs {
        inherit system;

        config.allowUnfree = true;
      };
      homeManagerModules = import ./modules/homeManager;
      mkNixos = system: homeUsers: config:
        nixpkgs.lib.nixosSystem {
          inherit specialArgs system;
          modules = [
            # agenix.nixosModules.default
            # devenv.nixosModules.default
            nur.nixosModules.nur
            home-manager.nixosModules.home-manager
            disko.nixosModules.disko
            # stylix.nixosModules.stylix
            ./modules/nixos
            {
              nixpkgs.overlays = [
                vscode-extensions.overlays.default
                nur.overlay
              ];
              home-manager = {
                extraSpecialArgs = {inherit inputs self;};
                useGlobalPkgs = true;
                useUserPackages = true;
                sharedModules = [
                  anyrun.homeManagerModules.default
                  self.homeManagerModules.default
                ];
                users = homeUsers;
              };
            }
            config
          ];
        };
      mkHome = config:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = specialArgs;
          modules = [
            self.homeConfigurations.default
            config
          ];
        };
    in {
      inherit homeManagerModules;
      nixosConfigurations = {
        lappy = mkNixos system {sky = import ./users/sky;} ./hosts/lappy;
      };
      homeConfigurations = {
        "sky@lappy" = mkHome ./users/sky;
      };
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          just
          alejandra
        ];

        shellHook = ''
        '';
      };
    };
}
