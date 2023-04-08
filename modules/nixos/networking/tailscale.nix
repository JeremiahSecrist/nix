{ config, pkgs, lib, ... }: {
  services.tailscale.enable = true;
  # Strict reverse path filtering breaks 
  # Tailscale exit node use and some subnet routing setups
  networking.firewall.checkReversePath = "loose";
  # add system package
  environment.systemPackages = with pkgs; [ tailscale ];
}
