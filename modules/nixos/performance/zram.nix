{ config, pkgs, lib, ... }:
{
  zramSwap.enable = lib.mkDefault true;
}