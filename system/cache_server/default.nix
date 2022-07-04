{ self, system, nixpkgs-small,  ... }:
let
pkgs = import nixpkgs-small {
    inherit system;
    config.allowUnfree = true;
};
lib = nixpkgs-small.lib;
in 
lib.nixosSystem {
  inherit system;
  modules = [
    ./configuration.nix
  ] ++ (with self.nixosModules; [
    common
    encryptedBoot
    docker
    openssh
    # harden
  ]);
}