_: { config, pkgs, lib, ... }:

{
    services.tailscale.enable = lib.mkDefault true;
}