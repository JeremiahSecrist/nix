{pkgs ? import <nixpkgs> {}}:
with pkgs;
  mkShell {
    buildInputs = [
      nixpkgs-fmt
      helix
      broot
      zsh
      zellij
      gitui
    ];

    shellHook = ''
    '';
  }
