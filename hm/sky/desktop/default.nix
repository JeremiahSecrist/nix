{ config, pkgs, stdenv, lib, ... }:

{
  imports = [ ./desktopU2f.nix ./noisetorch.nix ./display.nix ];
}
