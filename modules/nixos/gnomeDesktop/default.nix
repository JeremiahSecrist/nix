_: { config, pkgs, ... }:
{
services = {
    xserver = {
        enable = true;
        layout = "us";
        xkbVariant = "";
        displayManager = {
            gdm.enable = true;
            defaultSession = "gnome";
        };
        desktopManager = {
            xterm.enable = false;
            gnome.enable = true;
        };
    };
    udev.packages = [ pkgs.yubikey-personalization pkgs.gnome3.gnome-settings-daemon ];
    packagekit.enable = true;
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
programs = {
  xwayland.enable = true;
};
xdg.portal = {
  enable = true;
};
}
