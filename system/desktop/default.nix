{
  self,
  system,
  home-manager,
  nixpkgs,
  ...
}:
nixpkgs.lib.nixosSystem {
  inherit system;
  modules =
    [
      ./configuration.nix
      home-manager.nixosModules.home-manager
      {
        environment.etc."nix/inputs/nixpkgs".source = nixpkgs.outPath;
        nix.nixPath = ["nixpkgs=/etc/nix/inputs/nixpkgs"];
        nix.registry.nixpkgs.flake = nixpkgs;
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.sky = {
          # modules = [{ nix.registry.nixpkgs.flake = nixpkgs; }];
          imports = [../../hm/sky/home.nix ../../hm/sky/desktop];
        };
      }
    ]
    ++ (with self.nixosModules; [
      common
      sound
      yubikey
      u2fLogin
      gnomeDesktop
      boot
      docker
      virtual
      tailscale
    ]);
}
