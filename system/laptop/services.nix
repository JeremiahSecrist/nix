{ config, pkgs, ... }:
let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/02ab2e2aa58df6231c319af3ce1af79f3e82e2d8)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
in
{
services = {
    flatpak.enable = true; 
    auto-cpufreq.enable = true;
    printing.enable = true;
    resolved.fallbackDns = [
        "1.1.1.1"
        "1.0.0.1"
        "2606:4700:4700::1111,2606:4700:4700::1001"
    ];
    xserver = {
        enable = true;
        layout = "us";
        xkbVariant = "";
        libinput.enable = true;
        displayManager = {
            sddm.enable = true;
            defaultSession = "plasmawayland";
        };
        desktopManager = {
#           gnome.enable = true;
            plasma5.enable = true;
        };
    };
    pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = true;
    };
};
}