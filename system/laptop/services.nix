{ config, pkgs, ... }:
# let
#   unstable = import
#     (builtins.fetchTarball {
#         url = "https://github.com/nixos/nixpkgs/tarball/02ab2e2aa58df6231c319af3ce1af79f3e82e2d8";
#         sha256 = "1cmr9rwrs0aia8idzdrm3n5h7ajdkazjqlzkhy9l2qlb7vx7lw61";
#     } )
#     # reuse the current configuration
#     { config = config.nixpkgs.config; };
# in
{
services = {
    flatpak.enable = true; 
    auto-cpufreq.enable = true;
    printing.enable = true;
#    resolved.fallbackDns = [
#        "1.1.1.1"
#        "1.0.0.1"
#        "2606:4700:4700::1111,2606:4700:4700::1001"
#    ];
    xserver = {
        enable = true;
        layout = "us";
        xkbVariant = "";
        libinput.enable = true;
    };
    pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = true;
    };
    yubikey-agent.enable = true;
    pcscd.enable = true; # for yubikey
    # antivirus enabled with clamav
};
}