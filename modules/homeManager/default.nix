{
  waybar = import ./waybar;
  hyprland = import ./hyprland;
  noisetorch = import ./noisetorch;
  default = {
    imports = [
      ./waybar
      ./hyprland
      ./noisetorch
    ];
  };
}
