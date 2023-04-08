{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnumake
    nano
    git
    git-secret
  ];
}