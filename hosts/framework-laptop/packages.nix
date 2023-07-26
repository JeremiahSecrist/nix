{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    wofi
    foot
    waybar
    # rest of your packages
  ];
}
