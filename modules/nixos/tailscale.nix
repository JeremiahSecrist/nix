_: { config, pkgs, lib, ... }:

{
    services.tailscale.enable = lib.mkDefault true;
    # Strict reverse path filtering breaks 
    # Tailscale exit node use and some subnet routing setups
    networking.firewall.checkReversePath = lib.mkDefault "loose";
}