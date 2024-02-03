{
  ...
}: {
  programs.waybar = {
    enable = true;
    settings.mainBar = import ./mainbar.nix {};
    style = builtins.readFile ./style.css;
  };
}
