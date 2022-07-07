{ self, lib, system, ... }:
lib.nixosSystem {
  inherit system;
  modules = [
    ./configuration.nix
  ] ++ (with self.nixosModules; [
    # common
    boot
    docker
    openssh
  ]);
}