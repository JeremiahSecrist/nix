{ config, pkgs, stdenv, lib, ... }:

{
  imports = [ ./packages.nix ./desktopU2f.nix ./noisetorch.nix ./display.nix ];
}
