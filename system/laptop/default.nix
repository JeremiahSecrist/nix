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
        imports = [ ../../hm/sky/home.nix ../../hm/sky/laptop ];
      };
    }
  ] ++ (with self.nixosModules; [
    common
    sound
    yubikey
    u2fLogin
    gnomeDesktop
    encryptedBoot
    docker
    virtual
    # harden
  ]);
}
