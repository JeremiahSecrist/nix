{ config, pkgs, lib, ... }: {
  virtualisation.docker = {
    enable = true;
    liveRestore = false;
    autoPrune.enable = true;
  };
}
