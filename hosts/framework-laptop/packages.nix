{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    wofi
    foot
    waybar
    (pkgs.callPackage ./lemurs.nix {})
    # rest of your packages
  ];
}
