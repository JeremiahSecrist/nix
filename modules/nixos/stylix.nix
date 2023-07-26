{
  config,
  pkgs,
  ...
}: {
  stylix = {
    image = ../home-manager/sky/wallpapers/Darth-VaderSci-Fi-Star-Wars-4k-Ultra-HD-Wallpaper.jpg;
    polarity = "dark";
    targets = {
      gnome.enable = true;
      grub.enable = true;
      gtk.enable = true;
    };
  };
}
