{ self, lib, system, nixos-hardware, home-manager, ... }:
lib.nixosSystem {
  inherit system;
  modules = [
    ./configuration.nix
    nixos-hardware.nixosModules.framework-12th-gen-intel
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.sky = {
        imports = [ 
          ./configuration.nix
          ./hardware.nix
          ./modules.nix
          ./packages.nix
          ../../modules/home-manager/sky/home.nix
        ];
      };
    }
  ] 
}
