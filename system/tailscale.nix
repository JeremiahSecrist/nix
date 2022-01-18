{ config, pkgs, ... }:

{
    environment.systemPackages = [ pkgs.tailscale ];
    
    services.tailscale.enable = true;
    
    allowedUDPPorts = [ config.services.tailscale.port ];

}