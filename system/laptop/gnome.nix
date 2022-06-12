{ config, pkgs, ... }:
{
services = {
    xserver = {
        enable = true;
        displayManager = {
            gdm.enable = true;
            defaultSession = "gnome";
        };
        desktopManager = {
          gnome.enable = true;
        };
    };
    dbus.packages = [ pkgs.dconf ]; 
    udev.packages = [ pkgs.yubikey-personalization pkgs.gnome3.gnome-settings-daemon ];
};

# exclude the following packages from the default installation
environment.gnome.excludePackages = (with pkgs; [
  gnome-photos
  gnome-tour
]) ++ (with pkgs.gnome; [
  cheese # webcam tool
  gnome-music
#   gnome-terminal
  gedit # text editor
  epiphany # web browser
  geary # email reader
  evince # document viewer
  gnome-characters
  totem # video player
  tali # poker game
  iagno # go game
  hitori # sudoku game
  atomix # puzzle game
  
]);
xdg.portal = {
  enable = true;
  gtkUsePortal = true;
  # Add the GTK portal which seems to be always needed for GTK applications
  # extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
};
}