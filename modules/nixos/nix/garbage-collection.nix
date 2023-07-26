{
  config,
  pkgs,
  ...
}: {
  nix = {
    #auto maintainence
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    # prevent tampering
    # readOnlyNixStore = true;
  };
}
