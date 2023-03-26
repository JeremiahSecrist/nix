{ self, lib, system, nixos-hardware, home-manager, disko, ... }:
lib.nixosSystem {
  inherit system;
  modules = [
    ./configuration.nix
    ./configuration.nix
    ./hardware.nix
    ./modules.nix
    ./packages.nix
    nixos-hardware.nixosModules.framework-12th-gen-intel
    disko.nixosModules.disko
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.sky = {
        imports = [ 
          
          ../../modules/home-manager/sky/home.nix
        ];
      };
    }
  ] 
}
