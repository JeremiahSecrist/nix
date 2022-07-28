{ self, lib, system, home-manager,  ... }:
lib.nixosSystem {
  inherit system;
  modules = [
    ./configuration.nix
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.sky = {
        imports = [ ../../hm/sky/home.nix ../../hm/sky/laptopU2f.nix ];
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
