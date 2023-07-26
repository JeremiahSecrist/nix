{
  config,
  pkgs,
  ...
}: {
  nix = {
    sshServe = {
      enable = true;
    };
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      builders-use-substitutes = true
    '';
    distributedBuilds = true;
    settings = {
      keep-outputs = true;
      keep-derivations = true;
      trusted-public-keys = [
        "laptop-deploy:OMe69aOGxkvIhEYIECd1U3CE/PAouObowS7W4nDS460="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      secret-key-files = /var/lib/nix-keys/deploy.secret;
      allowed-users = [
        "@wheel"
        "@builders"
      ];
      trusted-users = [
        "root"
        "nix-ssh"
      ];
    };
  };
}
