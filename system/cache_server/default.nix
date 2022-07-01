{ system, home-manager, lib, self, ... }:

lib.nixosSystem {
  inherit system;
  modules = [
    ./configuration.nix
  ] ++ (with self.nixosModules; [
    common
    EncryptedBoot
    docker
    openssh
    # harden
  ]);
}