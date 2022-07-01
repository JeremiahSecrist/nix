{ system, home-manager, lib, self, ... }:

lib.nixosSystem {
  inherit system;
  modules = [
    ./configuration.nix
  ] ++ (with self.nixosModules; [
    common
    # sound
    # yubikey
    # u2fLogin
    # gnomeDesktop
    boot
    # harden
  ]);
}