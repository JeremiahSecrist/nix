{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/master"; # release-23.11
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
    disko = {
      url = "github:nix-community/disko/v1.3.0";
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
            impermanence.nixosModules.impermanence
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
                  # anyrun.homeManagerModules.default
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
      checks = {
        x86_64-linux = {
          default = pkgs.nixosTest {
            nodes.default = self.nixosConfigurations.lappy;
            # hostPkgs = pkgs;
            name = "basic test";
            testScript = ''
              machine.wait_for_unit("default.target")
              machine.succeed("su -- alice -c 'which firefox'")
              machine.fail("su -- root -c 'which firefox'")
            '';
          };
        };
      };
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          just
          alejandra
          nil
        ];

        shellHook = ''
        '';
      };
      nixConfig = {
        extra-trusted-public-keys = [
          "laptop-deploy:OMe69aOGxkvIhEYIECd1U3CE/PAouObowS7W4nDS460="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          # "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
          "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
        ];
        builders-use-substitutes = true;
        extra-substituters = [
          "https://cache.ngi0.nixos.org"
          "https://cache.nixos.org"
        ];
      };
    };
}
