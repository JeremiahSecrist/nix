{
  config,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      });
    })
  ];
  environment.systemPackages = with pkgs; [
    waybar
    wofi
    foot
    (pkgs.callPackage ./lemurs.nix {})
    # rest of your packages
  ];
}
