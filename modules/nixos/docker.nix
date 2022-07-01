_: { config, pkgs, lib, ... }:
{
    virtualisation.docker = {
        enable = true;
        liveRestore = true;
        autoPrune.enable = true;
    };
}