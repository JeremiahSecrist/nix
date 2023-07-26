{
  config,
  pkgs,
  lib,
  ...
}: let
  # opt = options.custom.desktop.gnome;
  cfg = config.custom.desktop.gnome;
in {
  options.custom.desktop.gnome = {
    enable = lib.mkEnableOption "This enables gnome desktop";
  };
  config = lib.mkIf cfg.enable {
    services = {
      gnome.gnome-keyring.enable = true;
      xserver = {
        enable = true;
        layout = "us";
        xkbVariant = "";
        displayManager = {
          gdm.enable = true;
          gdm.wayland = true;
          # defaultSession = lib.mkDefault "gnome";
        };
        desktopManager = {
          gnome.enable = lib.mkDefault true;
        };
      };
      udev.packages = [pkgs.yubikey-personalization pkgs.gnome3.gnome-settings-daemon];
    };

    # exclude the following packages from the default installation
    environment.gnome.excludePackages =
      (with pkgs; [gnome-photos gnome-tour])
      ++ (with pkgs.gnome; [
        cheese # webcam tool
        gnome-music
        #   gnome-terminal
        gedit # text editor
        epiphany # web browser
        geary # email reader
        evince # document viewer
        gnome-characters
        #totem # video player
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
      ]);
    programs = {
      xwayland.enable = lib.mkDefault true;
    };
    xdg.portal = {enable = lib.mkDefault true;};
  };
}
