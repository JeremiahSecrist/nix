{
  pkgs ? import <nixpkgs> {},
  nixago,
  nixago-ext,
}: let
  configs = {
    data = {
      proseWrap = "always";
    };
  };
in
  pkgs.mkShell {
    buildInputs = with pkgs; [
      alejandra
      wl-clipboard
      gitui
      helix
      broot
      zsh
      zellij
    ];

    shellHook = (nixago.lib.x86_64-linux.make (nixago-ext.prettier configs)).shellHook;
  }
