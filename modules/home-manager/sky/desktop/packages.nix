{ pkgs, lib, ... }: {
  home.packages = with pkgs;
    [

      looking-glass-client

    ];
}
