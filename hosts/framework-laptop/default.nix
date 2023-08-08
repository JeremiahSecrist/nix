{
  system,
  inputs,
  ...
}: let
  pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
in
  inputs.nixpkgs.lib.nixosSystem {
    inherit system; #= "x86_64-linux";
    specialArgs = {inherit inputs;};
    modules = [
      {
        environment.systemPackages = [
          inputs.devenv.packages.${pkgs.system}.devenv
        ];
      }
      ./configuration.nix
      ./hardware.nix
      ./modules.nix
      ./packages.nix
      inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
      inputs.disko.nixosModules.disko
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.sky = {
          imports = [
            inputs.hyprland.homeManagerModules.default
            ../../modules/home-manager/sky/home.nix
            ../../modules/home-manager/sky/laptop/dconf.nix
          ];
        };
      }
    ];
  }
